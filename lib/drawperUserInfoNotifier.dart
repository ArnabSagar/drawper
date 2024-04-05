import 'package:drawper/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drawper/drawperUserInfo.dart';
import 'package:flutter/material.dart';

class DrawperUserInfoNotifier extends ChangeNotifier {
  late DrawperUserInfo userInfo;
  bool _canUpdate = false; /* DO NOT LET IT update if we havent set a user yet cuz that makes no sense */
  DatabaseService databaseService = DatabaseService(); 

  void initPreferences() {
    notifyListeners();
  }

  Future<void> setUser(User newUser) async {
    String uid = newUser.uid; 

    Map<String, dynamic>? userData = await databaseService.getUserData(uid);
    print(userData);
    userInfo = DrawperUserInfo.fromMap(userData!, uid);
    _canUpdate = true; 
    notifyListeners();
    return;
  }

  Future<void> updateUserInfoInDatabase() async {
    if (!_canUpdate){
      return; 
    }
    // update in DB
    Map<String, dynamic> userData = userInfo.toMap();
    databaseService.updateUserData(userInfo.userId, userData);
    return;
  }

  void updateBio(String newBio) {
    if (!_canUpdate){
      return; 
    }

    // update the bio
    userInfo.bio = newBio;
    notifyListeners();
  }

  void updateName(String newName) {
    if (!_canUpdate){
      return; 
    }

    // update the name
    userInfo.name = newName;
    notifyListeners();
  }

  void updateProfilePicUrl(String newURL) {
    if (!_canUpdate){
      return; 
    }

    // update the url
    userInfo.profilePicUrl = newURL;
    notifyListeners();
  }

  void addFollowing(String username){
    if (!_canUpdate){
      return; 
    }

    userInfo.following.add(username);
    notifyListeners();
  }

  void removeFollowing(String username){
    if (!_canUpdate){
      return; 
    }

    userInfo.following.remove(username);
    notifyListeners();
  }
}