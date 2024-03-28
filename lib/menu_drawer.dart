import 'package:drawper/pages/draw_first.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'feed.dart';
import 'profile.dart';
import 'settings.dart';
import 'main.dart';
import 'pages/home_page.dart';

class MenuDrawer extends StatelessWidget {
  final User user;
  const MenuDrawer({Key? key, required this.user}) : super(key: key);

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
                'Drawper Menu',
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
              Icons.list_alt_outlined,
            ),
            title: const Text('Feed'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Feed(user: user)));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
            ),
            title: const Text('Your @Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Profile(user: user)));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person,
            ),
            title: const Text('Old Home Page/Menu (by austin)'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            user: user,
                          )));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Settings(
                            user: user,
                          )));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
            ),
            title: const Text('Draw First Info Page'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DrawFirst(
                            user: user,
                          )));
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
          ListTile(
            leading: const Icon(
              Icons.help_center_outlined,
            ),
            title: const Text('Help'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
