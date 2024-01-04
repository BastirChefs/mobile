// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors

import 'package:bastirchef/pages/edit_recipe.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'src/button.dart';
import 'package:bastirchef/pages/src/food_box.dart';

class RecipesByMe extends StatefulWidget {
  @override
  State<RecipesByMe> createState() => _RecipesByMeState();
}

class _RecipesByMeState extends State<RecipesByMe> {
  var userData = {};
  bool isLoading = false;
  List userRecipes = [];
  List<String> documentIds = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    documentIds = [];
    try {
      final recipeSnapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      recipeSnapshot.docs.forEach((doc) {
        documentIds.add(doc.id);
      });

      print('Document IDs: $documentIds');

      // var userSnap = await FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(FirebaseAuth.instance.currentUser!.uid)
      //     .get();

      // userData = userSnap.data()!;
      // print(userData);

      // userRecipes = userData['recipes'];
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  update() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'recipes': userRecipes});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  deleteRecipe(id) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance.collection('recipes').doc(id).delete();
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Recipes By Me",
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
                  for (var id in documentIds)
                    Column(
                      children: [
                        FoodBox(id: id),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Center the icons horizontally
                          children: [
                            // Delete Button
                            GestureDetector(
                              onTap: () {
                                deleteRecipe(id);
                                getData();
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.redAccent,
                                child: Icon(
                                  Icons.delete_outline_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                            SizedBox(width: 20), // Space between buttons
                            // Edit Button
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => EditRecipe(id: id),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color.fromARGB(255, 97, 103, 114),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
            ),
          )
          );
  }
}
