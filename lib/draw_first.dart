import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'feed.dart';
import 'draw.dart';
import 'profile.dart';
import 'settings.dart';
import 'main.dart';
import 'menudrawer.dart';

class DrawFirst extends StatefulWidget {
  const DrawFirst({Key? key}) : super(key: key);

  @override
  _DrawFirstState createState() => _DrawFirstState();
}

class _DrawFirstState extends State<DrawFirst> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "INFO",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.pink.shade500,
      ),
      drawer: const MenuDrawer(),
      body: Stack(
        children: [
          const Positioned(
            top: 75,
            left: 50,
            child: Text(
              "Drawp \ntoday’s \ndrawing!",
              style: 
                TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 48, height: 1.25),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          const Positioned(
            top: 275,
            left: 50,
            child: Text(
              """You can’t see other people’s \ndrawings until you drawp. \nThis makes your drawp 100%\noriginal.""",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700, height: 1),
            ),
          ),
          Positioned(
            top: 375,
            left: 100,
            child: IconButton(
              icon: Image.asset('assets/icons/tap_to_start_drawing.png'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Draw()));
              },
            )),
        ],
      ),
    );
  }
}
