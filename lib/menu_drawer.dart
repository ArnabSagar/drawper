import 'package:drawper/pages/draw_first.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'help.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 89, // Set the desired height
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.purple.shade900,
              ),
              child: const Text(
                'More Actions',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.help_center_outlined,
            ),
            title: const Text('Help'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const Help())
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.exit_to_app,
            ),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const MyHomePage(title: "Drawper Login Page")),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
