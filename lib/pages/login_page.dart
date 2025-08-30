import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/admin/admin_home_page.dart';
import 'package:full_project_1/pages/home_page.dart';
import 'package:full_project_1/pages/signup_page.dart';

import '../components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginAndSaveUser() async {
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user == null) throw "User not found";

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'uid': user.uid,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.lock_open_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 50),
            // welcome back, you've been missed
            Text(
              "Food Delivery App",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(height: 25),

            //email textfield
            MyTextfield(
              controller: emailController,
              hintText: "Email",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            //password textfield
            MyTextfield(
              controller: passwordController,
              hintText: "Password",
              obscureText: true,
            ),
            const SizedBox(height: 34),
            // sign in
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size(300, 50)),
              onPressed: () async {
                try {
                  // Admin check
                  final snapshot = await FirebaseFirestore.instance
                      .collection('Admin')
                      .where('email', isEqualTo: emailController.text.trim())
                      .get();

                  if (snapshot.docs.isNotEmpty) {
                    final adminDoc = snapshot.docs.first.data();

                    if (adminDoc['password'] ==
                        passwordController.text.trim()) {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AdminHomePage()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Incorrect admin password")),
                      );
                    }
                  } else {
                    await loginAndSaveUser();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login Failed: $e")),
                  );
                }
              },
              child: Text(
                'Login',
                style: TextStyle(
                    fontSize: 19,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            const SizedBox(height: 27),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => RegisterPage()));
              },
              child: Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}