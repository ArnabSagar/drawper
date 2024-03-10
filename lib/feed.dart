import 'package:drawper/post_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'menudrawer.dart';

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
        drawer: const MenuDrawer(),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
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
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostDetails(
                                            post: post,
                                          )));
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 15, 5, 10),
                                  child: Text(post['author']['username'],
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
