import 'package:drawper/pages/post_details.dart';
import 'package:flutter/material.dart';
import 'package:drawper/services/database.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  FeedState createState() => FeedState();
}

class FeedState extends State<Feed> {
  List<Map<String,dynamic>> _posts = [];
  // ignore: non_constant_identifier_names
  List<Map<String,dynamic>> _all_posts = [];
  bool everyone = false; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFromDb();
  }

  Future<void> loadFromDb() async {
    DatabaseService dbServ = DatabaseService();
    List<Map<String, dynamic>> followingPosts = await dbServ.getFollowingPostData();
    List<Map<String, dynamic>> allPosts = await dbServ.getAllPostData();
    setState(() {
      _posts = followingPosts;
      _all_posts = allPosts;
      isLoading = false;
    });
    // print(followingPosts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Today's Drawps!",
            textAlign: TextAlign.center,
          ),
        ),
        body: isLoading ? // Show loading indicator if isLoading is true
        const Center(
          child: CircularProgressIndicator(),
        ) 
        : Column(children: [
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
                      // print(_all_posts);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1))),
                  child: const Text("EVERYONE"),
                ),
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
