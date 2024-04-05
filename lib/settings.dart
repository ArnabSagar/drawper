import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'menu_drawer.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Settings",
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const MenuDrawer(),
      body: const Center(child: Text("Settings Page")),
    );
  }
}
