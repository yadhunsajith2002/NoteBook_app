import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/note_controller/note_controller.dart';
import 'package:todo_app/controller/search_controller/search_controller.dart';
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
    var searchProvider = context.read<SearchService>();

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
                if (value.isEmpty) {
                  setState(() {});
                }
                noteController.filterNotes(value);
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: "Search for Notes",
                prefixIcon: InkWell(
                  onTap: () {
                    noteController.filterNotes(searchController.text);
                    setState(() {});
                  },
                  child: Icon(Icons.search),
                ),
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
              future: searchProvider.getRecentSearches(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No recent searches',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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
                                child: InkWell(
                                  onTap: () {
                                    searchController.text = recentSearch;
                                  },
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
                                        onPressed: () async {
                                          await searchProvider
                                              .removeRecentSearch(recentSearch);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
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
            final filteredNotes = noteController.notes
                .where((note) => note.title
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .toList();

            if (filteredNotes.isEmpty) {
              // Show "Not Found" message when no search results
              return Center(
                child: Text(
                  'Not Found',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return InkWell(
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DescriptionScreen(
                                    title: note.title,
                                    description: note.description,
                                    date: note.date.toString(),
                                  )));
                          // Add the searched query to recent searches when a note is selected
                          searchProvider.addRecentSearch(searchController.text);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Card(
                            color: Colors.grey.shade800,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                note.title,
                                style: TextStyle(color: Colors.white),
                              ),
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
}
