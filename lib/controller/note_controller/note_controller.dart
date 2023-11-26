import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:todo_app/model/event_model.dart';

class NoteController extends ChangeNotifier {
  final Box<Note> _notesBox = Hive.box<Note>('notes');

  List<Note> notes = [];

  int existingNoteIndex = -1;

  // Load the data from the database
  Future<List<Note>> getNotes() async {
    return _notesBox.values.toList();
  }

  Future<void> loadNotes() async {
    final getNote = await getNotes();
    notes = getNote;
    notifyListeners();
  }

  // Add data to the database
  Future<void> addNote(Note note) async {
    await _notesBox.add(note);
    notifyListeners();
  }

  // Edit the saved data
  Future<void> editNote(int index, Note updatedNote) async {
    await _notesBox.putAt(index, updatedNote);
    notifyListeners();
  }

  // Delete the saved data
  Future<void> deleteNote(int index) async {
    await _notesBox.deleteAt(index);
    notifyListeners();
  }

  void filterNotes(String query) async {
    if (query.isEmpty) {
      // If the search query is empty, show all notes
      notes = await getNotes();
    } else {
      // Otherwise, filter notes based on the search query
      final allNotes = await getNotes();
      notes = allNotes.where((note) {
        return note.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
