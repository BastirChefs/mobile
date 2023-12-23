// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'src/button.dart';

class Profile extends StatelessWidget {
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
          body: ListView(
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
                            height:
                                8.0), // Add spacing between label and username
                        Text(
                          'gordon.ramsay', // Replace with the actual username
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
                          radius: 40.0, // Adjust the radius as needed
                          backgroundImage: AssetImage(
                              "lib/pages/src/images/baklava.jpg"), // Replace with your profile image
                        ),
                        SizedBox(
                            height:
                                8.0), // Add spacing between profile photo and text
                        GestureDetector(
                          onTap: () {
                            // Add your logic for changing the profile photo here
                          },
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.end, //to align icon and text
                            children: [
                              Text(
                                'Change Photo',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors
                                      .black, // You can change the color to match your design
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
                padding: EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    left: 20,
                    right: 200), // Add padding as needed
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center buttons vertically
                  crossAxisAlignment: CrossAxisAlignment
                      .stretch, // Stretch buttons horizontally
                  children: [
                    CustomButton(
                      text: 'Create Recipe',
                      onPressed: () {
                        // Add your logic for the "Create Recipe" button here
                        print('Create Recipe button pressed!');
                      },
                    ),
                    SizedBox(height: 10.0), // Add spacing between buttons
                    CustomButton(
                      text: 'Storage',
                      onPressed: () {
                        // Add your logic for the "Storage" button here
                        print('Storage button pressed!');
                      },
                    ),
                    SizedBox(height: 16.0), // Add spacing between buttons
                    CustomButton(
                      text: 'Recipes by Me',
                      onPressed: () {
                        // Add your logic for the "Recipes by Me" button here
                        print('Recipes by Me button pressed!');
                      },
                    ),
                  ],
                ),
              ),
              //3rd box: recipe lists
              // Expanded(
              //   child: Container(
              //     //height: 350,
              //     color: const Color.fromARGB(255, 161, 154, 172),
              //     padding: EdgeInsets.only(top: 20, left: 20,bottom: 20),
              //     child: Text("My Recipe Lists",
              //             style: TextStyle(
              //               fontSize: 20.0,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //   ),
              // ),
              Container(
                padding: EdgeInsets.all(16.0), // Add padding as needed
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Recipe Lists',
                          style: TextStyle(
                            fontSize: 20.0, // Adjust the font size as needed
                            fontWeight: FontWeight.bold, // Make the header bold
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("add list tapped");
                            // Add your logic for the "Add" button here
                            // This is where you can handle the add button click event
                          },
                          child: Icon(
                            Icons.add, // Replace with your preferred add icon
                            size: 24.0, // Adjust the icon size as needed
                            color: Color(
                                0xFFD75912), // Adjust the icon color as needed
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),

              //4th box: signout
              Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons
                          .exit_to_app, // Replace with your preferred signout icon
                      color:
                          Colors.red, // Replace with your preferred icon color
                      size: 24.0, // Replace with your preferred icon size
                    ),
                    SizedBox(width: 16.0), // Add spacing between icon and text
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 18.0, // Replace with your preferred text size
                        color: Colors
                            .black, // Replace with your preferred text color
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
