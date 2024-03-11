import 'package:drawper/menudrawer.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'profile.dart';

class DetailedUser extends StatefulWidget {
  const DetailedUser({Key? key}) : super(key: key);

  @override
  _DetailedUserState createState() => _DetailedUserState();
}

class _DetailedUserState extends State<DetailedUser> {
  dynamic _userData = {};

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  // Loads all of the JSON data for the profile page
  Future<void> _loadJsonData() async {
    String jsonString =
        await rootBundle.loadString('assets/test_files/profile_data2.json');
    Map<String, dynamic> jsonData = json.decode(jsonString);

    String pointsStr = getNumberDisplay(jsonData['points']);
    String followersStr = getNumberDisplay(jsonData['followers']);
    String drawpsStr = getNumberDisplay(jsonData['drawps']);

    setState(() {
      _userData = {
        ...jsonData,
        'pointsDisplay': pointsStr,
        'followersDisplay': followersStr,
        'drawpsDisplay': drawpsStr,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _userData.isEmpty ? "" : "@${_userData['username']}",
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.purple.shade900,
        ),
        resizeToAvoidBottomInset: false,
        body: _userData.isEmpty // TODO ADD FUTURE BUILDER HERE INSTEAD?
            ? const Center(
                child:
                    CircularProgressIndicator()) // Show loading indicator if data is not loaded
            : Column(
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
                                          image: NetworkImage(_userData[
                                              'profilePicUrl']))))),
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
                                    _userData['bio'],
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
                                                "${_userData['pointsDisplay']}",
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
                                                "${_userData['drawpsDisplay']}",
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
                                                "${_userData['followersDisplay']}",
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
                          Text(_userData['name'],
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
                          TextButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 233, 233, 233)),
                                foregroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 66, 66, 66)),
                              ),
                              onPressed: () => {},
                              child: const Text("Follow")),
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
                            icon: const Icon(Icons.report_outlined, size: 20, color: Colors.black45)
                          )
                        ]),
                    const SizedBox(height: 10), // spacer for aesthetics
                    Expanded(
                        child: Center(
                            child: Container(
                                // Feed of past drawps/posts
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(162, 198, 198, 198),
                                        width: 1)),
                                child: Scrollbar(
                                    thickness: 5,
                                    child: ListView.builder(
                                        itemCount: _userData['posts'].length,
                                        itemBuilder: (context, index) {
                                          var post =
                                              _userData['posts'][index];
                                          var viewsDisplay =
                                              getNumberDisplay(post['views']);
                                          var likesDisplay =
                                              getNumberDisplay(post['likes']);
                                          var dislikesDisplay =
                                              getNumberDisplay(
                                                  post['dislikes']);
                                          var dateDisplay =
                                              getDateDisplay(post['date']);
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
                                                decoration: const BoxDecoration(
                                                    // a preview image of the post
                                                    color: Colors.grey,
                                                    image: DecorationImage(
                                                      image: NetworkImage(
                                                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6EdI9EP2OioyOrJNAmtb0N3CDsP_jB6w6Gw&usqp=CAU"), //TODO: CHANGE TO "post['image']" when we have images loaded via json
                                                      fit: BoxFit.fill,
                                                    )),
                                              ),
                                              onTap: () {
                                                // TODO BRINGS THEM TO A DETAILED PAGE ABOUT THE POST
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
                  ]));
  }
}
