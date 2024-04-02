import 'package:drawper/services/database.dart';
import 'package:drawper/utils/toastMessage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final logger = ToastMessage();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String username) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Create a new user document for the new uid
      // await DatabaseService(uid: credential.user!.uid).updateUserData();
      await DatabaseService(uid: credential.user!.uid)
          .createUserData(email, username);

      await credential.user!.updateDisplayName(username);
      return credential.user;
    } catch (e) {
      logger.toast(message: 'Sign up error occured: $e');
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      logger.toast(message: '$e');
    }
  }
}
