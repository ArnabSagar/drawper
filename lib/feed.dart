import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'feed.dart';
import 'draw.dart';
import 'profile.dart';
import 'settings.dart';
import 'main.dart';
import 'draw_first.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List _posts = [];

  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/test_files/feed_data.json');
    final data = await json.decode(response);
    setState(() {
      _posts = data["feed"];
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Feed",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.pink.shade500,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.list_alt_outlined,
                ),
                title: const Text('Feed'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person,
                ),
                title: const Text('Your @Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                ),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Settings()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                ),
                title: const Text('Draw First Info Page'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DrawFirst()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                ),
                title: const Text('Log Out'),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MyHomePage(title: "Drawper Login Page")),
                      (route) => false);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.help_center_outlined,
                ),
                title: const Text('Help'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1))),
                  child: const Text("FRIENDS"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1))),
                  child: const Text("EVERYONE"),
                )
              ],
            ),
          ),
          Flexible(
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemCount: _posts.length,
                  itemBuilder: (BuildContext c, int i) {
                    Map post = _posts[i];
                    return Padding(
                        padding: const EdgeInsets.all(1.0),
                        // child: Text(post.toString()),
                        child: InkWell(
                            onTap: () {
                              /**
                           * MAKE SURE TO ROUTE FROM THE POST TO THE Detailed view
                           * */
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 15, 5, 10),
                                  child: Text(post['author']['id'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Image(
                                  image: NetworkImage(post['image_url']),
                                  fit: BoxFit.contain,
                                  width: 140,
                                  height: 140,
                                ),
                              ],
                            )));
                  })),
        ]));
  }
}
