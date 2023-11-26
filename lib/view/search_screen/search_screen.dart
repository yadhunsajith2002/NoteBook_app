// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_app/controller/note_controller/note_controller.dart';
// import 'package:todo_app/model/event_model.dart';

// class SearchScreen extends StatelessWidget {
//   SearchScreen({super.key});

//   final TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     var noteController = context.read<NoteController>();

//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         flexibleSpace: Center(
//           child: Padding(
//             padding: const EdgeInsets.only(left: 35, top: 25),
//             child: TextField(
//               autofocus: true,
//               controller: searchController,
//               onChanged: (value) {
//                 // Filter notes based on the search query
//                 noteController.filterNotes(value);
//               },
//               decoration: InputDecoration(
//                 hintText: "Search for Notes",
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(borderSide: BorderSide.none),
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: Consumer<NoteController>(
//         builder: (context, noteController, _) {
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: noteController.notes.length,
//                   itemBuilder: (context, index) {
//                     final note = noteController.notes[index];
//                     return Card(
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(15.0),
//                           child: Text(
//                             note.title,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/note_controller/note_controller.dart';
import 'package:todo_app/model/event_model.dart';
import 'package:todo_app/view/description_screen.dart/description_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var noteController = context.read<NoteController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 35, top: 25),
            child: TextField(
              autofocus: true,
              controller: searchController,
              onChanged: (value) {
                // Filter notes based on the search query
                if (value.isEmpty) {
                  // If the search query is empty, show recent searches
                  setState(() {});
                }
                noteController.filterNotes(value);
              },
              decoration: InputDecoration(
                hintText: "Search for Notes",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ),
      ),
      body: Consumer<NoteController>(
        builder: (context, noteController, _) {
          if (searchController.text.isEmpty) {
            // Show recent searches when the search query is empty
            return FutureBuilder<List<String>>(
              future: getRecentSearches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No recent searches',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        )),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          "Recent Searches",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final recentSearch = snapshot.data![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      recentSearch,
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        removeRecentSearch(recentSearch);
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            );
          } else {
            // Show filtered notes when a search query is entered
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: noteController.notes.length,
                    itemBuilder: (context, index) {
                      final note = noteController.notes[index];
                      return InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DescriptionScreen(
                                    title: note.title,
                                    description: note.description,
                                    date: note.date.toString(),
                                  )));
                          // Add the searched query to recent searches when a note is selected
                          addRecentSearch(searchController.text);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              note.title,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<List<String>> getRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recentSearches') ?? [];
  }

  Future<void> addRecentSearch(String searchQuery) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = prefs.getStringList('recentSearches') ?? [];
    recentSearches.insert(0, searchQuery);
    // Limit the number of recent searches, for example, keep the latest 5 searches
    recentSearches = recentSearches.take(5).toList();
    prefs.setStringList('recentSearches', recentSearches);
  }

  Future<void> removeRecentSearch(String searchQuery) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> recentSearches = prefs.getStringList('recentSearches') ?? [];
    recentSearches.remove(searchQuery);
    prefs.setStringList('recentSearches', recentSearches);
  }
}
