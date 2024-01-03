// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeList extends StatefulWidget {
  final String recipeListName; // Add this line to accept the recipe list name
  const RecipeList({Key? key, required this.recipeListName}) : super(key:key); // Modify the constructor

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  var userData = {};
  bool isLoading = false;
  List recipes = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      List existing_recipes = [];
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      print(userData);
      recipes = userData['recipe_list'][widget.recipeListName];

      for (var id in recipes) {
          var docSnapshot = await FirebaseFirestore.instance
              .collection('recipes')
              .doc(id)
              .get();

          if (docSnapshot.exists) {
            existing_recipes.add(id);
          }
        }
      recipes = existing_recipes;
      
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }
  
  removeRecipe(id) async {
    setState(() {
      isLoading = true;
    });
    try {
      String listName = widget.recipeListName;
      List<dynamic> recipesInList = userData['recipe_list'][widget.recipeListName];
      recipesInList.remove(id);
      print(recipesInList);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'recipe_list.$listName': recipesInList});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

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
                      for(var item in recipes) Column(
                      children: [
                        FoodBox(id: item),
                        GestureDetector(
                              onTap: () {
                                removeRecipe(item);
                                getData();
                                //update();
                              },
                              child: Text("Remove", style: TextStyle(color: Colors.red, fontSize: 12.0),)
                            ),
                        ],
                      ) 
                      // FoodBox(),
                    ],
                  ),
                ),
              )

      ),
    );
  }
}
