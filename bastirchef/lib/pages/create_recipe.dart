// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'src/button.dart'; // Ensure this import is correct for your CustomButton widget

class CreateRecipe extends StatefulWidget {
  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final List<String> ingredients = ["Example Ingredient 1", "Example Ingredient 2"];

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
                        ingredients.add('New Ingredient');
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
                  children: ingredients.map((ingredient) => Text(ingredient)).toList(),
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
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
