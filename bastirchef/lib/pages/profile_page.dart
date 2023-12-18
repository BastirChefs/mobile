import 'package:bastirchef/firebase_options.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF282828),
            leading: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFFE3E3E3),
              size: 40,
            ),
            title: Text(
              "Profile Page",
              style: TextStyle(
                color: Color(0xFFE3E3E3),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          body: SingleChildScrollView(
              child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children : [
                    Text("hello"),
                    Text("profile page will be added here")

                  ]))
          )
      ),
    );
  }
}
