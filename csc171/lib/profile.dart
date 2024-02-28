import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool isDarkMode = true;

  Future<void> getDarkMode() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = preferences.getBool("isDarkMode") ?? true;
    });
  }

  void setDarkMode(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool("isDarkMode", value);
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    getDarkMode();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Profile Page'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Profile Page Content',
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                'Dark Mode?',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Switch(
                value: isDarkMode,
                activeColor: Theme.of(context).colorScheme.secondary,
                onChanged: (value) => setDarkMode(value),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
