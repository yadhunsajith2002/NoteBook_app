import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/note_controller/note_controller.dart';
import 'package:todo_app/model/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/view/widgets/loading_shimmer.dart';

import 'package:todo_app/view/widgets/note_Card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  Color selectedColor = Colors.grey;

  List<Color> colorOptions = [
    Colors.grey,
    Color.fromARGB(255, 185, 185, 97),
    Color.fromARGB(255, 209, 183, 176),
  ];

  @override
  void initState() {
    super.initState();
    context.read<NoteController>().loadNotes();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        isloading = false;
      });
    });
  }

  bool isloading = true;

  @override
  Widget build(BuildContext context) {
    print("build");
    var providerWatch = context.watch<NoteController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: "Note",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: " Book",
                  style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 24,
                      fontWeight: FontWeight.w400))
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Consumer<NoteController>(
        builder: (context, providerWatch, _) {
          return isloading
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return SizedBox(height: 15);
                  },
                  separatorBuilder: (context, index) {
                    return ShimmerLoading();
                  },
                  itemCount: 10)
              : providerWatch.notes.isEmpty
                  ? Center(
                      child: Text(
                        'No notes yet. Add one!',
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: providerWatch.notes.length,
                            itemBuilder: (context, index) {
                              final note = providerWatch.notes[index];
                              final date =
                                  DateFormat.yMMMEd().format(note.date);
                              return NoteCard(
                                onEditPressed: () {
                                  providerWatch.existingNoteIndex = index;
                                  _addOrEditNote(context, existingNote: note);
                                },
                                onDeletePressed: () async {
                                  await providerWatch.deleteNote(index);
                                  providerWatch.loadNotes();
                                },
                                description: note.description,
                                title: note.title,
                                date: date,
                                color: note.color,
                                onRightslide: (details) async {
                                  await providerWatch.deleteNote(index);
                                  providerWatch.loadNotes();
                                },
                                onLeftslide: (details) {
                                  providerWatch.existingNoteIndex = index;
                                  _addOrEditNote(context, existingNote: note);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white54,
        onPressed: () {
          providerWatch.existingNoteIndex = -1;
          _addOrEditNote(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  void _addOrEditNote(BuildContext ctx, {Note? existingNote}) async {
    var providerRead = context.read<NoteController>();
    // var providerwatch = context.watch<NoteController>();

    final isEditing = existingNote != null;
    final newNote = isEditing
        ? Note.copy(existingNote)
        : Note(
            title: '',
            description: '',
            date: DateTime.now(),
            color: selectedColor.value,
          );
    final dateFormatter = DateFormat('dd-MM-yyyy');
    _titleController.text = newNote.title;
    _descriptionController.text = newNote.description;
    _dateController.text =
        isEditing ? dateFormatter.format(newNote.date.toLocal()) : '';

    int selectedColorIndex =
        isEditing ? colorOptions.indexOf(selectedColor) : -1;

    await showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Scaffold(
              appBar: AppBar(
                toolbarHeight: MediaQuery.of(context).size.height * 0.15,
                backgroundColor: Colors.black,
                centerTitle: true,
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
                title: Text(
                  isEditing ? 'Edit Note' : 'Add a New Note',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w500),
                ),
              ),
              backgroundColor: Colors.black,
              body: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(60))),
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    " Title",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 100,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      child: Center(
                                        child: TextField(
                                          maxLines: 6,
                                          controller: _titleController,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade400),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                              hintText: 'Title'),
                                          onChanged: (value) {
                                            newNote.title = value;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Description",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        child: TextField(
                                          controller: _descriptionController,
                                          onChanged: (value) {
                                            setState(() {
                                              newNote.description = value;
                                            });
                                          },
                                          maxLines: 20,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                              hintText: "Description",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade400),
                                              // hintMaxLines: 5,
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    " Date",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 60,
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          final selectedDate =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: newNote.date,
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2101),
                                          );
                                          if (selectedDate != null) {
                                            setState(() {
                                              newNote.date =
                                                  selectedDate.toUtc();
                                              _dateController.text =
                                                  dateFormatter.format(
                                                      newNote.date.toLocal());
                                            });
                                          }
                                        },
                                        child: AbsorbPointer(
                                          child: TextField(
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              hintText: "Date",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade400),
                                              suffixIcon:
                                                  Icon(Icons.calendar_month),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide.none),
                                            ),
                                            controller: _dateController,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "  Color",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      height: 80,
                                      child: Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 5,
                                        children: colorOptions
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          final index = entry.key;
                                          final color = entry.value;
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                selectedColor = color;
                                                selectedColorIndex = index;
                                                newNote.color = color.value;
                                              });
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Container(
                                                width:
                                                    index == selectedColorIndex
                                                        ? 60
                                                        : 50,
                                                height:
                                                    index == selectedColorIndex
                                                        ? 60
                                                        : 50,
                                                decoration: BoxDecoration(
                                                  color: color,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              bottomNavigationBar: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      if (_titleController.text.isNotEmpty &&
                          _descriptionController.text.isNotEmpty) {
                        newNote.title = _titleController.text;
                        newNote.description = _descriptionController.text;
                        newNote.color = selectedColor.value;

                        if (isEditing) {
                          await providerRead.editNote(
                              providerRead.existingNoteIndex, newNote);
                        } else {
                          await providerRead.addNote(newNote);
                        }

                        providerRead.loadNotes();
                        Navigator.of(context).pop();
                      } else {
                        // Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            padding: EdgeInsets.all(20),
                            backgroundColor: Colors.grey.shade300,
                            content: Center(
                              child: Text(
                                "Fields should not be left empty.",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 0,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              isEditing ? 'Save' : 'Add',
                              style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        color: Colors.black,
                        elevation: 0,
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        });
      },
    );
  }
}
