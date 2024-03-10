import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'menudrawer.dart';
import 'profile.dart';
import 'detailedUser.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<dynamic> _searchData = []; 

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  // Loads all of the JSON data for the profile page
  Future<void> _loadJsonData() async {
    String jsonString = await rootBundle.loadString('assets/test_files/search_data.json');

    setState(() {
      _searchData = json.decode(jsonString)['users'];
    });
  }

  TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchController.dispose();
    super.dispose();
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
        !_searchTerm.contains("m") || _searchData.isEmpty ? const Center(child: CircularProgressIndicator()) :
        Container(
          height: 400,
          child: ListView.builder(
        itemCount: _searchData.length,
        itemBuilder: (context, index) {
          var userInfo = _searchData[index];
          return ListTile(
            // an individual user relating to the search term
            title: Text(userInfo['username'], // Username
                style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 16)),
            subtitle: Text(userInfo['name'], // Name
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13)),
            leading: Container( // Profile picture
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.purple.shade900, strokeAlign: BorderSide.strokeAlignOutside),
                shape: BoxShape.circle,
                color: Colors.grey,
                image: DecorationImage(
                  image: NetworkImage(userInfo['profilePicUrl']),
                  fit: BoxFit.cover,
                )
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailedUser()));
            },
          );
        }
      )
      )
    );
  }
}
