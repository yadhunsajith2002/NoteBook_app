import 'package:flutter/material.dart';
import 'package:todo_app/controller/note_controller.dart';
import 'package:todo_app/model/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/view/widgets/note_Card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteController _noteController = NoteController();
  late List<Note> _notes = [];
  int existingNoteIndex = -1;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();

  Color selectedColor = Colors.grey;
  String selectedCategory = ""; // Initially empty category

  List<Color> colorOptions = [
    Colors.grey,
    Color.fromARGB(255, 185, 185, 97),
    Color.fromARGB(255, 209, 183, 176),
  ];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final categories = _noteController.getDistinctCategories();

    if (selectedCategory.isNotEmpty && !categories.contains(selectedCategory)) {
      // If the selected category is not in the list, set it to empty
      selectedCategory = "";
    }

    if (selectedCategory.isEmpty) {
      final notes = await _noteController.getNotes();
      setState(() {
        _notes = notes.reversed.toList();
      });
    } else {
      final notes = await _noteController.getNotesByCategory(selectedCategory);
      setState(() {
        _notes = notes.reversed.toList();
      });
    }
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
      body: _notes.isEmpty
          ? Center(
              child: Text('No notes yet. Add one!',
                  style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w400)),
            )
          : Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 50,
                  child: ListView.builder(
                    itemCount: _noteController.getDistinctCategories().length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedCategory = _noteController
                                  .getDistinctCategories()[index];
                              selectedIndex = index;
                              _loadNotes();
                            });
                          },
                          child: Chip(
                            backgroundColor:
                                selectedIndex == index ? Colors.grey : null,
                            label: Text(
                                _noteController.getDistinctCategories()[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      final note = _notes[index];
                      final date = DateFormat.yMMMEd().format(note.date);
                      return NoteCard(
                        onEditPressed: () {
                          existingNoteIndex = index;
                          _addOrEditNote(context, existingNote: note);
                        },
                        onDeletePressed: () async {
                          await _noteController.deleteNote(index);
                          _loadNotes();
                        },
                        description: note.description,
                        title: note.title,
                        date: date,
                        color: note.color,
                        onRightslide: (details) async {
                          await _noteController.deleteNote(index);
                          _loadNotes();
                        },
                        onLeftslide: (details) {
                          existingNoteIndex = index;
                          _addOrEditNote(context, existingNote: note);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white54,
        onPressed: () {
          existingNoteIndex = -1;
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
    final isEditing = existingNote != null;
    final newNote = isEditing
        ? Note.copy(existingNote)
        : Note(
            title: '',
            description: '',
            date: DateTime.now(),
            color: selectedColor.value,
            category:
                selectedCategory, // Updated to use selectedCategory directly
          );
    final dateFormatter = DateFormat('dd-MM-yyyy');
    _titleController.text = newNote.title;
    _descriptionController.text = newNote.description;
    _dateController.text =
        isEditing ? dateFormatter.format(newNote.date.toLocal()) : '';
    _categoryController.text = selectedCategory;

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
                  )),
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
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Category'),
                    controller: _categoryController,
                    onChanged: (value) {
                      setState(() {
                        newNote.category = value;
                      });
                    },
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
                            final category = _categoryController.text.isNotEmpty
                                ? _categoryController.text
                                : 'All';

                            newNote.title = _titleController.text;
                            newNote.description = _descriptionController.text;
                            newNote.category = category;
                            newNote.color = selectedColor.value;

                            if (isEditing) {
                              await _noteController.editNote(
                                  existingNoteIndex, newNote);
                            } else {
                              await _noteController.addNote(newNote);
                            }

                            _loadNotes();
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop();
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
                                    "Please add details",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
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
