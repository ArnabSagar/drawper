import 'dart:convert';
import 'package:drawper/drawperUserInfo.dart';
import 'package:drawper/drawperUserInfoNotifier.dart';
import 'package:drawper/pages/post_details.dart';
import 'package:drawper/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

import '../profile.dart';

// ignore: must_be_immutable
class DetailedUser extends StatefulWidget {
  DrawperUserInfo userInfo;
  DetailedUser({Key? key, required this.userInfo}) : super(key: key);

  @override
  _DetailedUserState createState() => _DetailedUserState();
}

class _DetailedUserState extends State<DetailedUser> {
  int followingRelationship = 0; // 0 = not following , 1 = following, 2 = it's u so u cnat follow urself
  int OGFR = 0;
  List<String> followButtonTextOptions = ["Follow", "Following", ""];
  String followButtonText = "Follow";


  @override
  void initState() {
    super.initState();
    // set inital following relationship
    DrawperUserInfoNotifier duin = Provider.of<DrawperUserInfoNotifier>(context, listen: false);
    if(duin.userInfo.userId == widget.userInfo.userId){
      updateFollowingRelationship(2);
      OGFR = 2;
    } else if (duin.userInfo.following.contains(widget.userInfo.userId)) {
      updateFollowingRelationship(1);
      OGFR = 1;
    } else {
      updateFollowingRelationship(0);
      OGFR = 0;
    }
  }

  void updateFollowingRelationship(int f) {
    setState(() {
      followingRelationship = f;
      followButtonText = followButtonTextOptions[f];
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              bool yft = false; 
              bool yuft = false;
              if(OGFR == 1 && followingRelationship == 0){
                yuft = true;
              } else if (OGFR == 0 && followingRelationship == 1){
                yft = true;
              }
              Navigator.pop(context, {"youFollowedThem": yft, "youUnfollowedThem": yuft}); // Navigate back to the previous page
            },
          ),
          title: Text(
            "@${widget.userInfo.username}",
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.purple.shade900,
        ),
        resizeToAvoidBottomInset: false,
        body: 
        // _userData.isEmpty // TODO ADD FUTURE BUILDER HERE INSTEAD?
        //     ? const Center(
        //         child:
        //             CircularProgressIndicator()) // Show loading indicator if data is not loaded
        //     : 
            Consumer<DrawperUserInfoNotifier> (builder: (context, duin, child) {
              
            
            return Column(
                // whole page
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    const SizedBox(height: 5), // spacer for aesthetics
                    // Row( // username display - (NOT NEEDED?)
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text("@${_userData['username']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                    //   ]
                    // ),
                    const SizedBox(height: 5), // spacer for aesthetics
                    Row(
                        // Profile picture plus user information
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 5), // spacer for aesthetics
                          SizedBox(
                              // profile picture section
                              height: 100,
                              width: 100,
                              child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.purple.shade900,
                                          width: 3,
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside),
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              widget.userInfo.profilePicUrl))))),
                          SizedBox(
                              // user info section beside profile picture
                              height: 100,
                              width: 200,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.userInfo.bio,
                                    style: const TextStyle(fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                      // User stats like points, drawps, followers
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${widget.userInfo.points}",
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                            const Text("Points",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${widget.userInfo.posts.length}",
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                            const Text("Drawps",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                "${widget.userInfo.followers.length}",
                                                style: const TextStyle(
                                                    fontSize: 14)),
                                            const Text("Followers",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        ),
                                      ])
                                ],
                              )),
                          const SizedBox(width: 5), // spacer for aesthetics
                        ]),
                    const SizedBox(height: 10), // spacer for aesthetics
                    Row(
                        // Name display of user
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 5),
                          Text(widget.userInfo.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 150),
                          const SizedBox(width: 5),
                        ]),
                    const SizedBox(height: 10), // spacer for aesthetics
                    Row(
                        // profile buttons like follow, block, report, etc
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (followingRelationship != 2) ?
                          TextButton(
                              style: followButtonText == "Following" ?
                                ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.purple.shade900),
                                  foregroundColor: const MaterialStatePropertyAll(
                                      Colors.white),
                                )
                                :
                                const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 233, 233, 233)),
                                  foregroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 66, 66, 66)),
                                ),
                              onPressed: () async {
                                if (followingRelationship == 0){
                                  // add this person to your following list
                                  duin.addFollowing(widget.userInfo.userId);
                                  await duin.updateUserInfoInDatabase();
                                  // adds you to their followers list 
                                  setState(() {
                                    widget.userInfo.followers.add(duin.userInfo.userId);
                                  });
                                  await DatabaseService().updateUserData(widget.userInfo.userId, widget.userInfo.toMap());
                                  updateFollowingRelationship(1);
                                } else if (followingRelationship == 1) {
                                  duin.removeFollowing(widget.userInfo.userId);
                                  await duin.updateUserInfoInDatabase();
                                  setState(() {
                                    widget.userInfo.followers.remove(duin.userInfo.userId);
                                  });
                                  await DatabaseService().updateUserData(widget.userInfo.userId, widget.userInfo.toMap());
                                  updateFollowingRelationship(0);
                                }
                                
                              },
                              child: Text(followButtonText)) : const SizedBox(width:10),
                          const SizedBox(width: 10), // spacer for aesthetics
                          TextButton(
                              style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 233, 233, 233)),
                                  foregroundColor: MaterialStatePropertyAll(
                                      Color.fromARGB(255, 66, 66, 66)),
                                ),
                              onPressed: () => {},
                              child: const Text("Email")),
                          const SizedBox(width: 10), // spacer for aesthetics
                          IconButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 233, 233, 233)),
                                foregroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 66, 66, 66)),
                              ),
                              onPressed: () => {},
                              icon: const Icon(Icons.report_outlined,
                                  size: 20, color: Colors.black45))
                        ]),
                    const SizedBox(height: 10), // spacer for aesthetics
                    Expanded(
                        child: Center(
                            child: Container(
                                // Feed of past drawps/posts
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            162, 198, 198, 198),
                                        width: 1)),
                                child: Scrollbar(
                                    thickness: 5,
                                    child: ListView.builder(
                                        itemCount: widget.userInfo.posts.length,
                                        itemBuilder: (context, index) {
                                          var post = widget.userInfo.posts[index];
                                          var viewsDisplay =
                                              getNumberDisplay(post['views']);
                                          var likesDisplay =
                                              getNumberDisplay(post['likes']);
                                          var dislikesDisplay =
                                              getNumberDisplay(
                                                  post['dislikes']);
                                          var dateDisplay =
                                              post['timestamp'];
                                          return Stack(children: [
                                            ListTile(
                                              // an individual previous post
                                              title: Text(dateDisplay,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16)),
                                              subtitle: Text(post['prompt'],
                                                  style: const TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 13)),
                                              trailing: Container(
                                                height: 60,
                                                width: 60,
                                                decoration: BoxDecoration(
                                                    // a preview image of the post
                                                    color: Colors.grey,
                                                    image: DecorationImage(
                                                      image: NetworkImage(post['imageURL']), 
                                                      fit: BoxFit.fill,
                                                    )),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => PostDetails(
                                                                post: post,
                                                              )));
                                              },
                                            ),
                                            Row(
                                                // Post stats display - views, likes, dislikes
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(
                                                      width:
                                                          100), // spacer for aesthetics
                                                  const SizedBox(
                                                      width:
                                                          100), // spacer for aesthetics
                                                  Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 10),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .black54,
                                                                  size: 15),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(viewsDisplay,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          12))
                                                            ]),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .thumb_up,
                                                                  color: Colors
                                                                      .green
                                                                      .shade600,
                                                                  size: 15),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(likesDisplay,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green
                                                                          .shade600,
                                                                      fontSize:
                                                                          12))
                                                            ]),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                  Icons
                                                                      .thumb_down,
                                                                  color: Colors
                                                                      .red
                                                                      .shade700,
                                                                  size: 15),
                                                              const SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  dislikesDisplay,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red
                                                                          .shade700,
                                                                      fontSize:
                                                                          12))
                                                            ]),
                                                      ]),
                                                  const SizedBox(
                                                      width:
                                                          100), // spacer for aesthetics
                                                ])
                                          ]);
                                        })))))
                  ]);},));
  }
}
