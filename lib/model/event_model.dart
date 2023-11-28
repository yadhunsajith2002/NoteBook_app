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
  late String category; // New field for category

  Note({
    required this.title,
    required this.description,
    required this.date,
    required this.category, // Updated field for category
  });

  Note.copy(Note other) {
    title = other.title;
    description = other.description;
    date = other.date;
    category = other.category; // Updated field for category
  }
}
