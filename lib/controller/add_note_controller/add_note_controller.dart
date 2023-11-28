import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNoteController extends ChangeNotifier {
  int currentIndex = 0;

  int? paymentMethod;

  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageList = [];
  selectImage() async {
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageList.addAll(selectedImages);
    }
    notifyListeners();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      selectedDate = pickedDate;
    }
    notifyListeners();
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      selectedTime = pickedTime;

      notifyListeners();
    }
  }

  getDateTime() {
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  onPayMode(int method) {
    paymentMethod = method;
    notifyListeners();
  }

  onScreenChange({required int index}) {
    currentIndex = index;
    notifyListeners();
  }
}
