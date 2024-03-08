import 'package:flutter/material.dart';

import 'feed.dart';
import 'draw.dart';
import 'profile.dart';
import 'settings.dart';
import 'main.dart';
import 'draw_first.dart';
import 'menudrawer.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.pink.shade500,
      ),
      drawer: const MenuDrawer(),
      body: const Center(child: Text("Settings Page")),
    );
  }
}
