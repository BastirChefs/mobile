import 'package:bastirchef/firebase_options.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'src/drop_down_text_field.dart';


class Favourites extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xFFE3E3E3),
          appBar: AppBar(
            backgroundColor: Color(0xFF282828),
            leading: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFFE3E3E3),
              size: 40,
            ),
              title: Text(
                "Favourites",
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
                    FoodBox(),
                    FoodBox(),
                    FoodBox(),
                    FoodBox(),
                    FoodBox(),

                  ]))
          )
      ),
    );
  }
}
