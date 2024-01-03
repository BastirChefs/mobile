import 'package:bastirchef/firebase_options.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bastirchef/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'src/drop_down_text_field.dart';


class Favourites extends StatefulWidget {

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  var userData = {};
  bool isLoading = false;
  List<dynamic> favourites = [];
  List<dynamic> existing_favs = [];

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
      favourites = [];
      existing_favs = [];
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      print(userData);
      
      if (userData.containsKey('favorite_recipes')) {
        favourites = userData['favorite_recipes'];
        print(favourites);

        for (var id in favourites) {
          var docSnapshot = await FirebaseFirestore.instance
              .collection('recipes')
              .doc(id)
              .get();

          if (docSnapshot.exists) {
            existing_favs.add(id);
          }
        }

        print(existing_favs);
    }
      setState(() {});
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
      //favourites = userData['favorite_recipes'];
      existing_favs.remove(id);
      var recipeSnap = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(id)
          .get();
      var recipeData = recipeSnap.data()!;
      var currentLikes = recipeData['reactions']['delicios'];
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(id)
          .update({'reactions.delicios': currentLikes - 1});
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'favorite_recipes': existing_favs});
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
                    SizedBox(height: 30),
                    for(var id in existing_favs) Column(
                      children: [
                        FoodBox(id: id),
                        GestureDetector(
                            onTap: () {
                              removeRecipe(id);
                              setState(() {});
                            },
                          child: Icon(
                            Icons.delete_outline_outlined, // Replace this with the desired icon
                            color: Colors.red, // Set the color of the icon
                            size: 30, // Set the size of the icon
                          ),),
                        SizedBox(height: 20),

                        ],
                      ) 
                  ]))
          )
      ),
    );
  }
}
