import 'package:flutter/material.dart';

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
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const MenuDrawer(),
      body: const Center(child: Text("Settings Page")),
    );
  }
}
