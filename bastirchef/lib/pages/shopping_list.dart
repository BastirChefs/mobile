import 'package:bastirchef/firebase_options.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


class ShoppingList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF282828),
            title: Text("Shopping List",
                style: TextStyle(color: Color(0xFFE3E3E3))),
          ),
          backgroundColor: Color(0xFFE3E3E3),
          body: SingleChildScrollView(
              child: Column(
                  children : [
                   Text("Hello"),
                   Text("Shopping list"),

                  ])
          )
      ),
    );
  }
}
