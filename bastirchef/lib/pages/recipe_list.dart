// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:bastirchef/pages/src/food_box.dart';

class RecipeList extends StatefulWidget {
  final List recipes;
  final String recipeListName; // Add this line to accept the recipe list name
  const RecipeList({Key? key, required this.recipes, required this.recipeListName}) : super(key:key); // Modify the constructor

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xFFE3E3E3),
          appBar: AppBar(
            backgroundColor: Color(0xFF282828),
            leading: GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xFFE3E3E3),
                size: 40,
              ),
            ),
              title: Text(
                "Recipe List",
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
                      SizedBox(height: 30),
                      Text(
                         widget.recipeListName, // Replace with your actual title
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20), // Optional: to provide some spacing after the title
                      for(var item in widget.recipes) FoodBox(id: item),
                      // FoodBox(),
                    ],
                  ),
                ),
              )

      ),
    );
  }
}
