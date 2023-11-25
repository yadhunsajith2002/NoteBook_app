import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/model/event_model.dart';

class NoteController {
  final Box<Note> _notesBox = Hive.box<Note>('notes');

  // Load the data from the database
  Future<List<Note>> getNotes() async {
    return _notesBox.values.toList();
  }

  // Add data to the database
  Future<void> addNote(Note note) async {
    await _notesBox.add(note);
  }

  // Edit the saved data
  Future<void> editNote(int index, Note updatedNote) async {
    await _notesBox.putAt(index, updatedNote);
  }

  // Delete the saved data
  Future<void> deleteNote(int index) async {
    await _notesBox.deleteAt(index);
  }

  // Add a method to get notes by category
  Future<List<Note>> getNotesByCategory(String category) async {
    return _notesBox.values.where((note) => note.category == category).toList();
  }

  // Add a method to get all distinct categories
  List<String> getDistinctCategories() {
    return _notesBox.values.map((note) => note.category).toSet().toList();
  }
}
