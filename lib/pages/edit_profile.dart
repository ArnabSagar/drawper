import 'package:drawper/utils/form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:drawper/profile.dart';
import 'package:drawper/services/database.dart';

class EditProfile extends StatefulWidget {
  final String uid;
  final dynamic userInfo;
  const EditProfile({Key? key, required this.uid, required this.userInfo}) : super(key: key);

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _profilePicController = TextEditingController();
  String currName = '';
  String currBio = '';
  String currProfilePicUrl = '';

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    dynamic userData = widget.userInfo;
    super.initState();
    _nameController.text = userData['name'].length == 0 ? '' : userData['name'];
    _bioController.text = userData['bio'].length == 0 ? '' : userData['bio'];
    _profilePicController.text = userData['profilePicUrl'].length == 0 ? '' : userData['profilePicUrl'];
    // Set current names for later reference
    currName = _nameController.text;
    currBio = _bioController.text;
    currProfilePicUrl = _profilePicController.text;
  }

  void _saveProfile() {
    DatabaseService ds = DatabaseService(uid: widget.uid);
    bool changesMade = false;
    // Perform saving logic for fields that are changed ONLY
    if (_nameController.text != currName) {
      print('Name has changed: ${_nameController.text}');
      widget.userInfo['name'] = _nameController.text;
      changesMade = true;
    }
    if (_bioController.text != currBio) {
      print('Bio has changed: ${_bioController.text}');
      widget.userInfo['bio'] = _bioController.text;
      changesMade = true;
    }
    if (_profilePicController.text != currProfilePicUrl) {
      print('Profile picture has changed: ${_profilePicController.text}');
      widget.userInfo['profilePicUrl'] = _profilePicController.text;
      changesMade = true;
    }

    if (changesMade) {
      ds.updateUserData(widget.uid, widget.userInfo);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    dynamic userData = widget.userInfo;
    final _formKey = GlobalKey<FormState>();
    String _name; // Initialize name variable
    String _bio; // Initialize name variable

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Edit Profile",
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                maxLength: 40, // Limit to 40 characters
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bioController,
                maxLines: null, // Allow multiple lines
                maxLength: 90, // Limit to 90 characters
                decoration: const InputDecoration(
                  labelText: 'Bio',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _profilePicController,
                decoration: const InputDecoration(
                  labelText: 'Profile Picture (URL)',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Save form data
                      _saveProfile();
                      // Pass updated data back to the previous screen
                      Navigator.pop(context, {
                        'name': _nameController.text,
                        'bio': _bioController.text,
                        'profilePicUrl': _profilePicController.text,
                      });
                    },
                    child: Text('Save'),
                  ),
                ]
              ),
            ],
          ),
        ),
      )
    );
  }
}
