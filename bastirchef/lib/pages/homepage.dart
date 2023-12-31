// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bastirchef/firebase_options.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:bastirchef/services/suggestion_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'src/drop_down_text_field.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var userData = {};
  List<Map<String, dynamic>> allIngredients = [];
  List<dynamic> suggestedRecipeIds = [];
  bool isLoading = true;
  List<int> selectedIds = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      print(userData);

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('ingredients').get();
      allIngredients = querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();
      allIngredients.forEach((doc) {
        print(doc);
      });

      final service = SuggestionService();
      var userId = FirebaseAuth.instance.currentUser!.uid;
      suggestedRecipeIds = await service.makeSuggestion(userId);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<int, String> getOptions() {
    Map<int, String> options = {};
    for(int i = 0; i < allIngredients.length; i++){
      options[i] = allIngredients[i]['name'];
    }
    return options;
  }

  // Future<void> getRecipeSuggestions() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   try {
  //     final service = SuggestionService();
  //     const userId = "RietHUeDDXWyYFmhJTzCGP4B7gQ2";
  //     final recipeIds = await service.makeSuggestion(userId);
  //     setState(() {
  //       suggestedRecipeIds = recipeIds;
  //     });
  //   } catch (e) {
  //     print('Error fetching recipe suggestions: $e');
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xFFE3E3E3),
          body: SingleChildScrollView(
              child: Column(children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width,
              padding:
                  EdgeInsets.only(top: 75, bottom: 10, right: 30, left: 30),
              decoration: BoxDecoration(
                color: Color(0xFF282828),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(35.0),
                  bottomRight: Radius.circular(35.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, ${userData['username']}",
                    style: TextStyle(
                      color: Color(0xFFD75912),
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 10), // Add spacing between the texts
                  Text(
                    "What would you like to cook today?",
                    style: TextStyle(
                      color: Color(0xFFE3E3E3),
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFE3E3E3),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: DropDownTextField(
                      buttonText: "Search",
                      textEditingController: TextEditingController(),
                      hint: 'Select Ingredients',
                      options: getOptions(),
                      // {
                      //   1: "Tomato",
                      //   2: "Patato",
                      //   3: "Chicken",
                      //   4: "Pasta",
                      //   5: "Pesto Sauce",
                      //   6: "Arrabiata Sauce",
                      //   7: "Filler",
                      //   8: "Filler",
                      //   9: "Filler",
                      //   10: "Filler",
                      //   11: "Filler"
                      // },
                      selectedOptions: [2, 3],
                      onChanged: (selectedIds) {
                        setState(() => selectedIds);
                        print(selectedIds);
                      },
                      multiple: true,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),

            if (suggestedRecipeIds.isNotEmpty)
              FoodBox(id: suggestedRecipeIds[0]),
            if (suggestedRecipeIds.length > 1)
              FoodBox(id: suggestedRecipeIds[1]),

            // FoodBox(),
            // FoodBox(),
            // FoodBox(),
          ]))),
    );
  }
}
