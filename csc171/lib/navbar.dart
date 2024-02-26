import 'package:flutter/material.dart';
import 'jobs/jobs.dart';
import './profile.dart';
import './home.dart';

class MyNavigator extends StatefulWidget {
  const MyNavigator({super.key});

  @override
  State<MyNavigator> createState() => _MyNavigatorState();
}

class _MyNavigatorState extends State<MyNavigator> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    // print(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //List of pages that I want to load
      body: IndexedStack(index: _selectedIndex, children: const <Widget>[
        MyHomePage(title: 'FFXIV Info Assistant Home Page'), //Home page
        JobsPage(title: 'Jobs Page'), //Jobs page
        ProfilePage(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
