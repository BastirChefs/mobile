// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'src/button.dart';

class CreateRecipe extends StatefulWidget {
  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF282828),
          leading: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFFE3E3E3),
            size: 40,
          ),
          title: Text(
            "Create Recipe",
            style: TextStyle(
              color: Color(0xFFE3E3E3),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
              Text("hello"),
              Text("creating recipe will be here")
            ]))));
  }
}
