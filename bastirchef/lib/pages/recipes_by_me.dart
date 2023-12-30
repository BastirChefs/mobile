// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors

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
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      print(userData);

      userRecipes = userData['recipes'];
      
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
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(id)
          .delete();
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
              child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children : [
                    Text("hello"),
                    Text("recipes by me will be here"),
                    for(var id in userRecipes) Column(
                      children: [
                        FoodBox(id: id),
                        GestureDetector(
                          onTap: () {
                            userRecipes.removeAt(userRecipes.indexOf(id));
                            deleteRecipe(id);
                            update();
                          },
                          child: Text("Remove", style: TextStyle(color: Colors.red, fontSize: 12.0),)
                        )
                      ],),
                  ]))
          )
      ),
    );
  }
}
