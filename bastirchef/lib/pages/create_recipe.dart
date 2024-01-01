// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors

import 'package:bastirchef/pages/src/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'src/button.dart'; // Ensure this import is correct for your CustomButton widget

class CreateRecipe extends StatefulWidget {
  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  var recipeData = {};
  var userData = {};
  List<Map<String, dynamic>> allIngredients = [];
  bool isLoading = false;
  List<dynamic> selectedIds = [];

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

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('ingredients').get();
      allIngredients = querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();
      
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Map<int, String> getOptions() {
    Map<int, String> options = {};
    for(int i = 0; i < allIngredients.length; i++){
      options[i] = allIngredients[i]['name'];
    }
    return options;
  }

  shareRecipe() async {
    setState(() {
      isLoading = true;
    });
    try {
      Map<String,dynamic> map ={'unit': 'gr', 'amount': 1};
      Map<String, Map<String,dynamic>> ings = Map.fromIterable(
        selectedIds,
        key: (k) => k,
        value: (v) => map,
      );
      var recipe = {
        'recipeName': _titleTextController.text.toString(),
        'recipeText': _descriptionTextController.text.toString(),
        'comments': [],
        'reactions':{ 'delicios': 0, 'looksGood': 0, 'oghk': 0},
        'timeCreated': DateTime.now(),
        'ingredients': ings,
        'mainIngredients': selectedIds,
        'userId': FirebaseAuth.instance.currentUser!.uid,
      };
      await FirebaseFirestore.instance
        .collection('recipes')
        .add(recipe); 
      } catch (e) {
      print(e);
      }
    
    setState(() {
      isLoading = false;
    });
  }


  void _addIngredient() {
    DropDownState(
      DropDown(
        buttonText: "Add",
        options: getOptions(),
        selectedOptions: [],
        selectedItems: (List<dynamic> selectedList) {
          setState(() {
            selectedIds = selectedList;
            print(selectedIds);
          });
          // Logic to add selected ingredients to the ingredients list
        },
        enableMultipleSelection: true,
      ),
    ).showModal(context);
  }

  final List<String> ingredients = [
    "Example Ingredient 1",
    "Example Ingredient 2"
  ];

  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
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
          "Create Recipe",
          style: TextStyle(
            color: Color(0xFFE3E3E3),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40, bottom: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleTextController,
                decoration: InputDecoration(
                  labelText: "Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  CustomButton(
                    text: 'Add Ingredient',
                    onPressed: () {
                      setState(() {
                        // ingredients.add('New Ingredient');
                        _addIngredient();
                      });
                    },
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: selectedIds
                      .map((ingredient) => Text(ingredient))
                      .toList(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionTextController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Share',
                onPressed: () {
                  print('Share');
                  shareRecipe();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
