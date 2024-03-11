import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'draw_first.dart';
import 'dart:io';
import 'dart:';

void main() {
  HttpOverrides.global =
      MyHttpOverrides(); // TODO : Note this is a hacky thing because images from url were having certificate error
  runApp(const MyApp());
  HttpOverrides.global = MyHttpOverrides();
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawper',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.purple.shade900,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple.shade900),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Drawper Login Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// ignore: unused_element
void _login() {
  // TODO: LOGIN FUNCTIONALITY
}

void _create() {
  // TODO: CREATE ACCOUNT FUNCTIONALITY
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Set the status bar color
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.purple
          .shade900, // Change this color to your desired status bar color
      statusBarIconBrightness: Brightness.light,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 100),
            Text(
              "Drawper",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 25),
            const SizedBox(
              width: 300,
              child: TextField(
                decoration: InputDecoration(labelText: "Username"),
              ),
            ),
            const SizedBox(
              width: 300,
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
            ),
            const SizedBox(height: 50),
            TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.purple.shade900),
                  foregroundColor: const MaterialStatePropertyAll(Colors.white),
                  overlayColor: const MaterialStatePropertyAll(
                      Color.fromARGB(255, 56, 15, 106)),
                ),
                onPressed: () => {
                      Navigator.pop(context),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DrawFirst()), // TODO ADD LOGIC FOR CHECKING IF THEY HAVE DONE THE DRAWP OF THE DAY OR NOT YET
                          (route) => false)
                    },
                child: const Text("Login",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 70),
            const TextButton(
              onPressed: _create,
              child: Text("Create an account"),
            )
          ],
        ),
      ),
    );
  }
}
