import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/controller/note_controller/note_controller.dart';
import 'package:todo_app/model/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/view/add_notes_screen/add_notes_screen.dart';

import 'package:todo_app/view/widgets/note_Card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteController>().loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    print("build");

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
                              // _addOrEditNote(context, existingNote: note);
                            },
                            onDeletePressed: () async {
                              await providerWatch.deleteNote(index);
                              providerWatch.loadNotes();
                            },
                            description: note.description,
                            title: note.title,
                            date: date,
                            onRightslide: (details) async {
                              await providerWatch.deleteNote(index);
                              providerWatch.loadNotes();
                            },
                            onLeftslide: (details) {
                              providerWatch.existingNoteIndex = index;
                              // _addOrEditNote(context, existingNote: note);
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
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => NoteAddScreen()));
        },
        child: Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }
}
