import 'package:drawper/menu_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'pages/edit_profile.dart';

class Profile extends StatefulWidget {
  final User user;

  const Profile({Key? key, required this.user}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

// Generates the desired display of the given integer - eg. 4200 -> "4.2K"
String getNumberDisplay(int number) {
  double numAsDouble = number.toDouble();
  String identifier = "";

  if (number >= 1000000) {
    numAsDouble = (numAsDouble / 100000).round().toDouble() / 10;
    identifier = "M";
  } else if (number >= 1000) {
    numAsDouble = (numAsDouble / 100).round().toDouble() / 10;
    identifier = "K";
  } else {
    // below 1000
    return number.toString();
  }

  if (numAsDouble % 1 == 0) {
    // whole number
    return numAsDouble.toInt().toString() + identifier;
  } // otherwise show one decimal
  return numAsDouble.toStringAsFixed(1) + identifier;
}

// Generates the desired display of the given date, which must be in YYYY-MM-DD format
String getDateDisplay(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('MMMM d, yyyy').format(dateTime);
  return formattedDate;
}

class ProfileState extends State<Profile> {
  dynamic _profileData = {};
  dynamic _userData = {};
  String uid = "N/A";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Loads all of the user data for the profile page
  Future<void> _loadUserData() async {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is signed in, retrieve their data from Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Assuming the UID is used as the document ID
          .get();

      // Access user data
      if (userSnapshot.exists) {
        // User document exists, you can access its data
        _userData = userSnapshot.data();
        print('User data: $_userData');
      } else {
        // User document doesn't exist, handle accordingly
        print('User document does not exist.');
      }
    } else {
      // No user signed in, handle accordingly
      print('No user signed-in.');
      return;
    }

    String pointsStr = getNumberDisplay(_userData['points']);
    String followersStr = getNumberDisplay(_userData['followers'].length);
    String drawpsStr = getNumberDisplay(_userData['posts'].length);

    setState(() {
      _profileData = {
        ..._userData,
        'pointsDisplay': pointsStr,
        'followersDisplay': followersStr,
        'drawpsDisplay': drawpsStr,
      };
      uid = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            _profileData.isEmpty ? "" : "@${_profileData['username']}",
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.purple.shade900,
        ),
        drawer: MenuDrawer(user: widget.user),
        resizeToAvoidBottomInset: false,
        body: _profileData.isEmpty // TODO ADD FUTURE BUILDER HERE INSTEAD?
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
                    //     Text("@${_profileData['username']}", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
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
                                          image: NetworkImage(_profileData[
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
                                    _profileData['bio'],
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
                                                "${_profileData['pointsDisplay']}",
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
                                                "${_profileData['drawpsDisplay']}",
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
                                                "${_profileData['followersDisplay']}",
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_profileData['name'],
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 5),
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
                              onPressed: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(uid: uid, userInfo: _userData),
                                  ),
                                ).then((updatedUserData) {
                                  if (updatedUserData != null) {
                                    // Update the UI with the updated data
                                    setState(() {
                                      _userData = updatedUserData;
                                      _loadUserData();
                                    });
                                  }
                                })
                              },
                              child: const Text("Edit Profile")),
                          const SizedBox(width: 10), // spacer for aesthetics
                          TextButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 233, 233, 233)),
                                foregroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 66, 66, 66)),
                              ),
                              onPressed: () => {},
                              child: const Text("Share Profile")),
                          const SizedBox(width: 10), // spacer for aesthetics
                          IconButton(
                              style: const ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 233, 233, 233)),
                                foregroundColor: MaterialStatePropertyAll(
                                    Color.fromARGB(255, 66, 66, 66)),
                              ),
                              onPressed: () => {},
                              icon: const Icon(Icons.settings,
                                  size: 20, color: Colors.black45)),
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
                                child: _profileData['posts'].isEmpty ? const Center(child: Text("No drawps yet!")) : Scrollbar(
                                    thickness: 5,
                                    child: ListView.builder(
                                        itemCount: _profileData['posts'].length,
                                        itemBuilder: (context, index) {
                                          var post =
                                              _profileData['posts'][index];
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
