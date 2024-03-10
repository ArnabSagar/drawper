import 'dart:ui';

import 'package:drawper/post_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'menudrawer.dart';

class Feed extends StatefulWidget {
  final Uint8List? newDrawing; 

  const Feed({Key? key, this.newDrawing}) : super(key: key);

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
                  itemCount: widget.newDrawing != null? _posts.length + 1 : _posts.length,
                  itemBuilder: (BuildContext c, int i) {

                    if (i == 0 && widget.newDrawing != null) {
                        return Container(
                        padding: const EdgeInsets.all(1.0),
                        height: 160,
                        child: InkWell(
                            onTap: () {
                              
                            },
                            child: Column(
                              children: [
                                const Text("yourusername",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                const SizedBox(height: 1),
                                Image.memory(
                                  widget.newDrawing!,
                                  fit: BoxFit.contain,
                                  width: 120,
                                  height: 120,
                                ),
                              ],
                            )));
                    }

                    Map post = _posts[widget.newDrawing != null? i-1: i];
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
                                Text(
                                  post['author']['username'], 
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500
                                  )
                                ),
                                const SizedBox(height: 1),
                                Image(
                                  image: NetworkImage(post['image_url']),
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
