import 'package:drawper/drawperUserInfoNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

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
    _profilePicController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DrawperUserInfoNotifier drawperUserInfoNotifier = Provider.of<DrawperUserInfoNotifier>(context);

    _nameController.text = drawperUserInfoNotifier.userInfo.name;
    _bioController.text = drawperUserInfoNotifier.userInfo.bio;
    _profilePicController.text = drawperUserInfoNotifier.userInfo.profilePicUrl;

    final _formKey = GlobalKey<FormState>();

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
                      drawperUserInfoNotifier.updateName(_nameController.text);
                      drawperUserInfoNotifier.updateBio(_bioController.text);
                      drawperUserInfoNotifier.updateProfilePicUrl(_profilePicController.text);
                      drawperUserInfoNotifier.updateUserInfoInDatabase();
                      // Pass updated data back to the previous screen
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
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
