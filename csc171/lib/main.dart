import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode = true;

  Future<void> getDarkMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = preferences.getBool("isDarkMode") ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // setDarkMode(true);
    getDarkMode();
    return MaterialApp(
      title: 'FFXIV Info Assistant',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.grey,
          secondary: Color(0xFFD50000),
        ),
      ),
      theme: ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFD50000),
          secondary: Colors.grey,
        ),
      ),
      home: const MyNavigator(),
    );
  }
}
