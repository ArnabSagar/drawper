import 'package:flutter/material.dart';

class Draw extends StatefulWidget {
  const Draw({Key? key}) : super(key: key);

  @override
  _DrawState createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("DRAW PAGE")
      ),
    );
  }
}
