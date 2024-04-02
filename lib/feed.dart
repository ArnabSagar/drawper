import 'package:drawper/pages/post_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:drawper/services/database.dart';
import 'dart:convert';

class Feed extends StatefulWidget {
  final Uint8List? newDrawing;
  final User user;

  const Feed({Key? key, this.newDrawing, required this.user}) : super(key: key);

  @override
  FeedState createState() => FeedState();
}

class FeedState extends State<Feed> {
  List<dynamic> _posts = [];
  List<dynamic> _all_posts = [];
  bool everyone = false; 

  @override
  void initState() {
    super.initState();
    loadFromDb();
    // readJson();
  }

  // Future<void> readJson() async {
  //   final String response =
  //       await rootBundle.loadString('assets/test_files/feed_data.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     _posts = data["feed"];
  //   });
  // }

  Future<void> loadFromDb() async {
    DatabaseService db_serv = DatabaseService(uid: widget.user.uid);
    setState(() {
      _posts = db_serv.getFollowingPostData() as List;
      _all_posts = db_serv.getAllPostData() as List;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Feed",
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      everyone = false; 
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1))),
                  child: const Text("FRIENDS"),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      everyone = true; 
                    });
                  },
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
                    Map<String, dynamic> post = everyone ? _all_posts[i] : _posts[i];
                    return Container(
                        padding: const EdgeInsets.all(1.0),
                        height: 160,
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
                                Text(post['authorUName'],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(height: 1),
                                Image(
                                  image: NetworkImage(post['imageURL']),
                                  fit: BoxFit.contain,
                                  width: 120,
                                  height: 120,
                                ),
                              ],
                            )));
                  })),
        ]));
  }
}
