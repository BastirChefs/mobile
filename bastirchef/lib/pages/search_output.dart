// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:isolate';

import 'package:bastirchef/pages/src/drop_down_text_field.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchOutput extends StatefulWidget {
  final List<String>? options;
  const SearchOutput({Key? key, required this.options}) : super(key:key);

  @override
    State<SearchOutput> createState() => _SearchOutputState();
}
  class _SearchOutputState extends State<SearchOutput> {
    bool isLoading = true;
    List<Map<String, dynamic>> allIngredients = [];
    List<Map<String, dynamic>> allRecipes = [];
    List<String> recipeIds = [];
    List<String> selectedIds = [];
    List<String> outputRecipes = [];

    @override
    void initState() {
      super.initState();
      getData();
    }

    Future<void> getData() async {
      try {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('ingredients').get();
        allIngredients = querySnapshot.docs
            .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
            .toList();
          
        final recipeSnapshot =
            await FirebaseFirestore.instance.collection('recipes').get();
        allRecipes = recipeSnapshot.docs
            .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
            .toList();
        recipeSnapshot.docs.forEach((doc) => recipeIds.add(doc.id));

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

    searchOutputRecipes(options) {
      for(int i = 0; i < allRecipes.length; i++){
        for(int j = 0; j < options.length; j++){
          if(allRecipes[i]['ingredients'][options[j]] != null){
            outputRecipes.add(recipeIds[i]);
          }
        }
      }
      print(outputRecipes);
    }

    @override
    Widget build(BuildContext context) {
      return MaterialApp(  
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Color(0xFFE3E3E3),
          body: SingleChildScrollView(
              child: Column(
                  children : [Container(

                    height: MediaQuery.of(context).size.height * 0.20,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 75, bottom: 10, right: 30, left: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //SizedBox(height: 15,),
                        Container(
                          decoration: BoxDecoration(
                            color : Color.fromARGB(255, 187, 187, 187),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: DropDownTextField(
                            buttonText: "Search",
                            textEditingController: TextEditingController(),
                            hint: 'Select Ingredients',
                            options: getOptions(),
                            selectedOptions: [],
                            onChanged: (selectedIds) {
                              setState(() => selectedIds);
                              searchOutputRecipes(selectedIds);
                            },
                            multiple: true,
                        ),
                        )
                      ],
                    ),
                  ),
                    SizedBox(height: 10),
                    for(var item in outputRecipes) 
                      FoodBox(id: item),
                    // FoodBox(),
                    // FoodBox(),
                    // FoodBox(),
                    // FoodBox(),

                  ])
          )
        ),
      );
    }
  }