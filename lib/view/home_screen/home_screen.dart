import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/note_controller/note_controller.dart';
import 'package:todo_app/model/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    var providerWatch = context.watch<NoteController>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
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
            Icon(
              Icons.edit_outlined,
              color: Colors.white,
            ),
          ],
        ),
        backgroundColor: Colors.black,
      ),
      body: Consumer<NoteController>(
        builder: (context, providerWatch, _) {
          return providerWatch.notes.isEmpty
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
                          final date = DateFormat.yMMMEd().format(note.date);
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
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      isEditing ? 'Edit Note' : 'Add a New Note',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Title'),
                    controller: _titleController,
                    onChanged: (value) {
                      newNote.title = value;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Description'),
                    controller: _descriptionController,
                    onChanged: (value) {
                      setState(() {
                        newNote.description = value;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: newNote.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          newNote.date = selectedDate.toUtc();
                          _dateController.text =
                              dateFormatter.format(newNote.date.toLocal());
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: 'Date '),
                        controller: _dateController,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 80,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 5,
                      children: colorOptions.asMap().entries.map((entry) {
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
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              width: index == selectedColorIndex ? 50 : 40,
                              height: index == selectedColorIndex ? 50 : 40,
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () async {
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
                            Navigator.of(context).pop();

                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: Text(
                                      "Please add full details!!!",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  );
                                });
                          }
                        },
                        child: Text(isEditing ? 'Save' : 'Add'),
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
