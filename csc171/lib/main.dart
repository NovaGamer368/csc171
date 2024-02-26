import 'package:flutter/material.dart';
import './navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFXIV Info Assistant',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
        primary: Colors.grey,
        secondary: Color(0xFFD50000),
      )),
      home: const MyNavigator(),
    );
  }
}
