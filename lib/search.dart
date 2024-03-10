import 'package:flutter/material.dart';

import 'menu_drawer.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
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
      drawer: const MenuDrawer(),
      body: Center(child: Text('Search Term: $_searchTerm')),
    );
  }
}
