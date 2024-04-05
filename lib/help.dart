import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  HelpState createState() => HelpState();
}

class HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Help",
          textAlign: TextAlign.center,
        ),
      ),
      body: const Center(child: Text("Help Page")),
    );
  }
}
