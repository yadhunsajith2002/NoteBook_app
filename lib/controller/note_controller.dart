import 'package:hive_flutter/adapters.dart';
import 'package:todo_app/model/event_model.dart';

class NoteController {
  final Box<Note> _notesBox = Hive.box<Note>('notes');

  Future<List<Note>> getNotes() async {
    return _notesBox.values.toList();
  }

  Future<void> addNote(Note note) async {
    await _notesBox.add(note);
  }

  Future<void> editNote(int index, Note updatedNote) async {
    await _notesBox.putAt(index, updatedNote);
  }

  Future<void> deleteNote(int index) async {
    await _notesBox.deleteAt(index);
  }
}
