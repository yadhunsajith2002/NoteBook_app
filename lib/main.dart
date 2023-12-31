import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/controller/home_controller/home_controller.dart';
import 'package:todo_app/controller/note_controller/note_controller.dart';
import 'package:todo_app/controller/search_controller/search_controller.dart';
import 'package:todo_app/model/event_model.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/view/splash_screen/splash_screen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  await Hive.openBox<Note>('notes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteController()),
        ChangeNotifierProvider(create: (context) => HomeController()),
        ChangeNotifierProvider(create: (context) => SearchService())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData.dark(useMaterial3: true),
        home: SplashScreen(),
      ),
    );
  }
}
