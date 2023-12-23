// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors

import 'package:bastirchef/pages/create_recipe.dart';
import 'package:bastirchef/pages/recipes_by_me.dart';
import 'package:flutter/material.dart';
import 'src/button.dart';
import 'storage_page.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<String> userRecipeLists = [
    'Breakfast Recipes',
    'Dinner Ideas',
    'Healthy Snacks',
    'Breakfast Recipes',
    'Dinner Ideas',
  ];
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
            "Profile Page",
            style: TextStyle(
              color: Color(0xFFE3E3E3),
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //1st box: profile photo, username label, username
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          'gordon.ramsay',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundImage:
                              AssetImage("lib/pages/src/images/baklava.jpg"),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Change Photo',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(Icons.edit),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              //2nd box: create recipe, recipe created by me,my storage
              Container(
                padding:
                    EdgeInsets.only(top: 16, bottom: 16, left: 20, right: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      text: 'Create Recipe',
                      onPressed: () {
                        print('Create Recipe button pressed!');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateRecipe(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10.0),
                    CustomButton(
                      text: 'Storage',
                      onPressed: () {
                        print('Storage button pressed!');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Storage(),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.0),
                    CustomButton(
                      text: 'Recipes by Me',
                      onPressed: () {
                        print('Recipes by Me button pressed!');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipesByMe(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              //3rd box: My Recipe Lists with Add button
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Recipe Lists',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                userRecipeLists.add('New Recipe List');
                              });
                            },
                            child: Icon(
                              Icons.add,
                              size: 24.0,
                              color: Color(0xFFD75912),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey, // Set the border color
                            width: 2.0, // Set the border width
                          ),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: userRecipeLists.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                userRecipeLists[index],
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    userRecipeLists.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //4th box: signout
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                      size: 24.0,
                    ),
                    SizedBox(width: 16.0),
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
