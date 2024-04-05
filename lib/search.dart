import 'package:drawper/drawperUserInfo.dart';
import 'package:drawper/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

// import 'menu_drawer.dart';
// import 'profile.dart';
import 'pages/detailedUser.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  List<Map<String,dynamic>> _searchData = [];
  List<Map<String,dynamic>> _allProfiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  // Loads all of the user profiles
  Future<void> _loadProfiles() async {
    List<Map<String,dynamic>> profiles = await DatabaseService().getAllUsersData();
    setState(() {
      _allProfiles = profiles;
    });
  }

  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchController.dispose();
    super.dispose();
  }

  void updateSearchData() {
    setState( () {
      _searchData = _allProfiles.where((user) => user.containsKey('username') && user['username'].toString().startsWith(_searchTerm)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: TextField(
            textAlignVertical: TextAlignVertical.bottom,
            controller: _searchController, // Assign the controller
            onChanged: (value) {
              setState(() {
                _searchTerm = value;
              });
              updateSearchData();
            },
            decoration: InputDecoration(
              constraints: const BoxConstraints(maxHeight: 40),
              filled: true,
              fillColor: Colors.white, // Background color
              hintText: 'Search...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black), // Text color
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchTerm = '';
                  _searchController.clear(); // Clear the text field
                });
              },
            ),
          ],
        ),
        body: 
            SizedBox(
                height: 400,
                child: ListView.builder(
                    itemCount: _searchData.length,
                    itemBuilder: (context, index) {
                      var userInfo = _searchData[index];
                      return ListTile(
                        // an individual user relating to the search term
                        title: Text(userInfo['username'], // Username
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(userInfo['name'], // Name
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 13)),
                        leading: Container(
                          // Profile picture
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2,
                                  color: Colors.purple.shade900,
                                  strokeAlign: BorderSide.strokeAlignOutside),
                              shape: BoxShape.circle,
                              color: Colors.grey,
                              image: DecorationImage(
                                image: NetworkImage(userInfo['profilePicUrl']),
                                fit: BoxFit.cover,
                              )),
                        ),
                        onTap: () {
                          DrawperUserInfo uifo = DrawperUserInfo.fromMap(userInfo, userInfo["id"].toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailedUser(userInfo: uifo) 
                                  ) 
                            ).then((updatess) {
                              if(updatess['youFollowedThem']){
                                User? you = FirebaseAuth.instance.currentUser;
                                setState((){
                                  userInfo['followers'].add(you!.uid);
                                });
                              }
                              if(updatess['youUnfollowedThem']){
                                User? you = FirebaseAuth.instance.currentUser;
                                setState((){
                                  userInfo['followers'].remove(you!.uid);
                                });
                              }
                            });
                        },
                      );
                    })));
  }
}
