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
    var recipeData = {};
    var userData = {};
    bool isLoading = false;
    var username;

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
        username = userData['username'];

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

    addToFav() async {
      setState(() {
        isLoading = true;
      });
      var currentLikes = recipeData['reactions']['delicios'];
      try {
        await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.id)
          .update({'reactions.delicios': currentLikes+1});

        await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'favorite_recipes': widget.id}, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }
      setState(() {
        isLoading = false;
      });
    }

    addComment(comment) async {
      setState(() {
        isLoading = true;
      });
      try {
        Map commentMap = {
          'comment': comment,
          'createdAt': DateTime.now(),
          'userId': username,
        };
        print(commentMap);

        await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.id)
          .set({'comments': commentMap}, SetOptions(merge: true));
      } catch (e) {
        print(e);
      }
      setState(() {
        isLoading = false;
      });
    }

    List checkMissingIngredients() {
      setState(() {
        isLoading = true;
      });
      List missingItems = []; 
      var keyList = recipeData['ingredients'].keys;
      for(var keys in keyList){
        var ingredient = recipeData['ingredients'][keys];
        if(userData['storage'][keys] == null){
          var key = ingredient;
          var value = ingredient['amount'];
          Map item = {key: value};
          missingItems.add(item);
        }
        else if(userData['storage'][keys] < ingredient['amount']){
          var key = ingredient;
          var value = ingredient['amount'] - userData['storage'][keys];
          Map item = {key: value};
          missingItems.add(item);
        }
      }
      setState(() {
        isLoading = false;
      });
      return missingItems;
    }

    addToList(listName) async {
      setState(() {
        isLoading = true;
      });
      try {
        var addedList = userData['recipe_list'][listName].add(widget.id);
        await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'recipe_list.$listName': addedList});
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