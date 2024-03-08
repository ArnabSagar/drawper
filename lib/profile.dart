import 'package:drawper/menudrawer.dart';
import 'package:flutter/material.dart';

import 'feed.dart';
import 'draw.dart';
import 'profile.dart';
import 'settings.dart';
import 'main.dart';
import 'draw_first.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.pink.shade500,
      ),
      drawer: const MenuDrawer(),
      body: const Center(child: Text("PROFILE PAGE")),
    );
  }
}
