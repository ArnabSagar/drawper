import 'package:flutter/material.dart';

import 'homePage.dart';
import 'feed.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
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

void _login() {
  // TODO: LOGIN FUNCTIONALITY
}

void _create() {
  // TODO: CREATE ACCOUNT FUNCTIONALITY
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.purple),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                  overlayColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 112, 29, 126)),
                ),
                onPressed: () => {
                      Navigator.pop(context),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const Feed()),
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
