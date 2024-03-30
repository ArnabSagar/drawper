import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../draw.dart';

class DrawFirst extends StatefulWidget {
  final User user;
  const DrawFirst({Key? key, required this.user}) : super(key: key);

  @override
  DrawFirstState createState() => DrawFirstState();
}

class DrawFirstState extends State<DrawFirst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Drawp!",
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20), // spacer for aesthetics
          const Center(
            // Title
            child: Text(
              "Today’s Drawp",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 42),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(height: 10), // spacer for aesthetics
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              // description
              """You can’t see other people’s posts until you Drawp, which makes your masterpiece 100% original.""",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, height: 1),
            ),
          ),
          const SizedBox(height: 10), // spacer for aesthetics
          IconButton(
            icon: Image.asset('assets/icons/tap_to_start_drawing.png'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Draw(user: widget.user)));
            },
          ),
          const SizedBox(height: 30), // spacer for aesthetics
        ],
      ),
    );
  }
}
