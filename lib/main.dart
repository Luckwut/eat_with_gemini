import 'package:flutter/material.dart';
import 'views/home/home_page_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // assert(() {
  //   // Your debug-only code here
  //   // debugInsert();
  //   return true; // Always return true in debug mode
  // }());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eat With Gemini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const HomePageScreen(),
    );
  }
}
