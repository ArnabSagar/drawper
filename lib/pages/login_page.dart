import 'package:drawper/pages/create_account_page.dart';
import 'package:drawper/pages/draw_first.dart';
import 'package:drawper/pages/home_page.dart';
import 'package:drawper/services/storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drawper/utils/form.dart';
import 'package:drawper/utils/toastMessage.dart';
import 'package:drawper/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final showMessage = ToastMessage();
  bool _isSigning = false;
  final AuthService _auth = AuthService();
  final StorageService _storage = StorageService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Image(
                  image: AssetImage('assets/images/DrawperFullLogo.png'),
                  width: 325),
              const SizedBox(
                height: 30,
              ),
              FormContainer(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              const SizedBox(
                height: 10,
              ),
              FormContainer(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  _signIn(context);
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.purple.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: _isSigning
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // GestureDetector(
              //   onTap: () {
              //     _signInWithGoogle();
              //   },
              //   child: Container(
              //     width: double.infinity,
              //     height: 45,
              //     decoration: BoxDecoration(
              //       color: Colors.red,
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //     child: Center(
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(
              //             FontAwesomeIcons.google,
              //             color: Colors.white,
              //           ),
              //           SizedBox(
              //             width: 5,
              //           ),
              //           Text(
              //             "Sign in with Google",
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateAccountPage()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.purple.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDateString() {
    DateTime now = DateTime.now();
    String date = DateTime(now.year, now.month, now.day)
        .toString()
        .replaceAll("00:00:00.000", "");
    return date;
  }

  void _signIn(BuildContext context) async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSigning = false;
    });

    String fileName = "${user?.uid.toString()}_${_getDateString()}";

    if (user != null) {
      showMessage.toast(message: "Successfully logged in");
      String fileNameCheck = await _storage.getDownloadURL(fileName);
      if (context.mounted && fileNameCheck == "") {
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => DrawFirst(
                      user: user,
                    )),
            (route) => false);
      } else if (context.mounted && fileNameCheck != "") {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage(user: user)));
      }
    } else {
      showMessage.toast(message: "Login failed!");
    }
  }

  // _signInWithGoogle() async {
  //   final GoogleSignIn _googleSignIn = GoogleSignIn();

  //   try {
  //     final GoogleSignInAccount? googleSignInAccount =
  //         await _googleSignIn.signIn();

  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //           await googleSignInAccount.authentication;

  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         idToken: googleSignInAuthentication.idToken,
  //         accessToken: googleSignInAuthentication.accessToken,
  //       );

  //       await _firebaseAuth.signInWithCredential(credential);
  //       Navigator.pushNamed(context, "/home");
  //     }
  //   } catch (e) {
  //     showToast(message: "some error occured $e");
  //   }
  // }
}
