import 'package:flutter/material.dart';

import 'package:todo_app/view/home_screen/home_screen.dart';
import 'package:todo_app/view/search_screen/search_screen.dart';

class HomeController extends ChangeNotifier {
  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
  ];
  int selectedIndex = 0;
  void ontap(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
