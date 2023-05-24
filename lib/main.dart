import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taharicha_admin/firebase_options.dart';
import 'package:taharicha_admin/reportsPage.dart';
import 'package:taharicha_admin/userProfile.dart';
import 'package:taharicha_admin/usersPage.dart';
import 'package:taharicha_admin/posts.dart';
import 'homePage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        "UsersScreen": (context) => UsersScreen(),
        "ReportsScreen": (context) => ReportsScreen(),
        "PostsScreen": (context) => PostsScreen(),
      },
    );
  }
}
