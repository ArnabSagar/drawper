import 'package:flutter/material.dart';

import 'menudrawer.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Feed",
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const MenuDrawer(),
      body: Center(child: Text("FEED PAGE")),
    );
  }
}
