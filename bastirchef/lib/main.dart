// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:bastirchef/firebase_options.dart';
import 'package:bastirchef/pages/login_screen.dart';
import 'package:bastirchef/pages/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'pages/homepage.dart';
import 'pages/src/bottom_nav_bar.dart';
import 'pages/favourites.dart';
import 'pages/shopping_list.dart';
import 'pages/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
        //body: Homepage(),
        body: LogInScreen(),
        )
    );
  }
}
