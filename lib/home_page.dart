import 'package:flutter/material.dart';

import 'feed.dart';
import 'search.dart';
import 'profile.dart';
import 'menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  //For changing the screen
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //This is a screens list which you want to navigate through BottomNavigationBar
  final List<Widget> _children = [const Feed(), const Search(), const Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const MenuDrawer(),
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 25,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.purple.shade900,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            label: "Feed",
            icon: Icon(Icons.home_filled),
          ),
          BottomNavigationBarItem(
            label: "Search",
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person),
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
