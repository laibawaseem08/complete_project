import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/components/my_drawer_list_tile.dart';
import 'package:full_project_1/pages/login_page.dart';
import 'package:full_project_1/pages/setting_page.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // app logo
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Icon(
              Icons.lock_open_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          // home list title
          MyDrawerListTile(
            text: "H O M E",
            icon: Icons.home,
            onTap: () => Navigator.pop(context),
          ),

          // settings list title
          MyDrawerListTile(
              text: "S E T T I N G",
              icon: Icons.settings,
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              }),

          const Spacer(),
          // logout list title

          GestureDetector(
            onTap: () {
              logout(context);
            },
            child: const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 28, bottom: 30),
                  child: Icon(
                    Icons.logout,
                    size: 23,
                  ),
                ),
                SizedBox(width: 8),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Text(
                    "Logout",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}