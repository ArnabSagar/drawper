import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawper/utils/toastMessage.dart';
import 'dart:math';

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

  Future createPostData(String authorUName, String authorUID, String imageURL, String timestamp, String prompt) async { 

    Random random = Random();
    int likes = random.nextInt(100); 
    int dislikes = random.nextInt(100);
    int views = random.nextInt(100);

    return await drawpsCollection.doc(uid).set({
      // Key value pairs of the user properties when creating a new account
      "likes": likes, //randomize 
      "dislikes": dislikes,
      "views": views,
      "imageURL": imageURL,
      "authorUName": authorUName,
      "authorUID": authorUID,
      "timestamp": timestamp,
      "prompt": prompt,
      "comments": [{"userId": "bruh", "userName": "plankton", "commentStr":"omg so cool!"}, {"userId": "bruh2", "userName": "squidward", "commentStr":"i could do it better tbh."} ],
    });
  }

  Future<List<Map<String,dynamic>>> getAllPostData() async {
    // Query to get all documents from the collection
    QuerySnapshot querySnapshot = await drawpsCollection.get();

    // List to hold the results
    List<Map<String, dynamic>> resultList = [];

    // Iterate through the documents
    for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
      // Convert each document to a Map
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      resultList.add(data);
    }

    // Return the list of documents
    return resultList;
  }

  Future<List<Map<String,dynamic>>> getFollowingPostData() async {
    // TODO
    return getAllPostData();
  }
}
