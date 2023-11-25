import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime date;

  @HiveField(3)
  late int color;

  @HiveField(4) // Add this line for the category field
  late String category;

  Note({
    required this.title,
    required this.description,
    required this.date,
    required this.color,
    required this.category, // Add this line to the constructor
  });

  Note.copy(Note other) {
    title = other.title;
    description = other.description;
    date = other.date;
    color = other.color;
    category = other.category; // Add this line to the copy constructor
  }
}
