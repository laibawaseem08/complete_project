import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/admin/add_products.dart';
import 'package:full_project_1/admin/all_items.dart';
import 'package:full_project_1/admin/order_screen.dart';
import 'package:full_project_1/admin/user_screen.dart';
import 'package:full_project_1/pages/login_page.dart';
import 'package:full_project_1/themes/light_mode.dart';


class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: lightMode,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Admin Dashboard',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 23,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Colors.blue,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 70),
              _buildAdminOption(
                context,
                image: "lib/images/manage/order.png",
                text: "Order Management",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => OrdersScreen()));
                },
              ),
              const SizedBox(height: 70),
              _buildAdminOption(
                context,
                image: "lib/images/manage/users.png",
                text: "User Credentials",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserScreen()));
                },
              ),
              const SizedBox(height: 70),
              _buildAdminOption(
                context,
                image: "lib/images/manage/Update icon.png",
                text: "Menu Management",
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AllItems()));
                },
              ),
              const SizedBox(height: 70),
              _buildAdminOption(
                context,
                image: "lib/images/manage/add.png",
                text: "Add Items",
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddProductScreen(
                              restaurantId: 'cSXoUxJHxZbHpO8OvEgL')));
                },
              ),
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminOption(BuildContext context,
      {required String image, required String text, required Function onTap}) {
    return Container(
      width: 360,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 23),
            child: Image.asset(image, height: 90),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: GestureDetector(
              onTap: () => onTap(),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


