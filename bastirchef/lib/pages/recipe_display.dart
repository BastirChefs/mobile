// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDisplay extends StatefulWidget {
  final String id;
  const RecipeDisplay({Key? key, required this.id}) : super(key:key);
  
  @override
    State<RecipeDisplay> createState() => _RecipeDisplayState();
}

  class _RecipeDisplayState extends State<RecipeDisplay> {
    var recipeData= {};
    bool isLoading = false;

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
        var recipeSnap = await FirebaseFirestore.instance
            .collection('recipes')
            .doc(widget.id)
            .get();

        recipeData = recipeSnap.data()!;
        print(recipeData);
        
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
          body: SingleChildScrollView(
              child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children : [
                    Text("hello"),
                    Text("recipe display will be added here")

                  ]))
          )
        ),
      );
    }
  }