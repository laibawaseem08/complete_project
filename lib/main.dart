import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:full_project_1/admin/admin_home_page.dart';
import 'package:full_project_1/components/my_button.dart';
import 'package:full_project_1/components/my_drawer.dart';
import 'package:full_project_1/components/my_textfield.dart';
import 'package:full_project_1/models/restaurant.dart';
import 'package:full_project_1/pages/auth_page.dart';
import 'package:full_project_1/pages/home_page.dart';
import 'package:full_project_1/pages/login_page.dart';
import 'package:full_project_1/pages/setting_page.dart';
import 'package:full_project_1/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
        providers: [
          // theme provider
          ChangeNotifierProvider(create: (context) => ThemeProvider()),

          // restaurant provider
          ChangeNotifierProvider(create: (context) => Restaurant()),
        ],

        child: const MyApp()
    ),

    );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        theme: themeProvider.themeData,
      );
    });
  }
}
