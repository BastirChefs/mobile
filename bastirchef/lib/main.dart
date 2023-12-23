// ignore_for_file: use_key_in_widget_constructors

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
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    SignUpScreen(),
    LogInScreen(),
    Homepage(),
    Favourites(),
    ShoppingList(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        home: Scaffold(
        //body: Homepage(),
        body: _screens[_currentIndex],
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          backgroundColor: Color(0xFF282828),
          selectedItemColor: Color(0xFFD75912),
          unselectedItemColor: Color(0xFFE3E3E3),
          items: [
            /// SignUp
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("SignUp"),
            ),
            /// Login
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("LogIn"),
            ),
            /// Home
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: Icon(Icons.star),
              title: Text("Favourites"),
            ),

            /// Search
            SalomonBottomBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text("Shopping List"),
            ),

            /// Profile
            SalomonBottomBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
            ),
          ],
        ),
        )
    );
  }
}
