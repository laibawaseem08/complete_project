
import 'package:final_year_project/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/settings_page.dart';
import 'my_drawer_list_tile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    // Go back to login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                     MaterialPageRoute(builder: (context)=> const SettingsPage())
                 );
              }
          ),


          const Spacer(),
          // logout list title

          GestureDetector(
            onTap: (){
              logout(context);
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 28,bottom: 30),
                  child: Icon(
                      Icons.logout,
                    size: 23,
                  ),
                ),
                SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Text(
                      "Logout",
                    style: TextStyle(
                      fontSize: 24
                    ),
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
