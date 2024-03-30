import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawper/utils/toastMessage.dart';

class DatabaseService {
  final String uid;
  final logger = ToastMessage();

  DatabaseService({required this.uid});

  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference drawpsCollection =
      FirebaseFirestore.instance.collection('drawps');

  Future createUserData(String email, String username) async {
    try {
      return await usersCollection.doc(uid).set({
        // Key value pairs of the user properties when creating a new account
        "username": username,
        "name": "",
        "email": email,
        "profilePicUrl":
            "https://i.pinimg.com/564x/7f/26/e7/7f26e71b2c84e6b16d4f6d3fd8a58bca.jpg",
        "bio": "",
        "points": 0,
        "followers": [],
        "following": [],
        "posts": []
      });
    } catch (e) {
      logger.toast(message: 'Error occured while creating user data: $e');
    }
  }

  Future updateUserData() async {
    return await usersCollection.doc(uid).set({
      // Function to update user data, edited by user through profile settings
      // profile picture, bio, name.
      /* You shouldn't be able to change the user's 
          1. email
          2. followers - it is updated only if someone follows or unfollows you
          3. following - it is updated only if you follow or unfollow someone
          4. posts - should only change when creationg or deleting posts
          5. points          
      */
    });
  }

  Future createPostData(String authorUName, String authorUID, String imageURL, String timestamp) async { 
    return await usersCollection.doc(uid).set({
      // Key value pairs of the user properties when creating a new account
      "likes": 6, //randomize 
      "dislikes": 2,
      "views": 8,
      "imageURL": imageURL,
      "authorUName": authorUName,
      "authorUID": authorUID,
      "timestamp": timestamp,
      "comments": [{"userId": "bruh", "commentStr":"omg so cool!"}], // make sure aligns with post detial view json thing
    });
  }

  Future getPostData() async {
    return await usersCollection.get();
  }
}
