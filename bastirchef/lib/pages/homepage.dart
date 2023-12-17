import 'package:bastirchef/firebase_options.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'src/drop_down_text_field.dart';


class Homepage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Color(0xFFE3E3E3),
          body: SingleChildScrollView(
              child: Column(
                  children : [Container(

                    height: MediaQuery.of(context).size.height * 0.32,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 75, bottom: 10, right: 30, left: 30),
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
                          "Hello, User Name",
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
                        SizedBox(height: 15,),
                        Container(
                          decoration: BoxDecoration(
                            color : Color(0xFFE3E3E3),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: DropDownTextField(
                          textEditingController: TextEditingController(),
                          hint: 'Select Category',
                          options: {1:"tomato",2:"patato",3:"chicken",4:"pasta"},
                          selectedOptions: [2,3],
                          onChanged: (selectedIds) {
                            // setState(() => selectedIds);
                          },
                          multiple: true,
                        ),
                        )
                      ],
                    ),
                  ),
                    SizedBox(height: 10),
                    FoodBox(),
                    FoodBox(),
                    FoodBox(),
                    FoodBox(),
                    FoodBox(),

                  ])
          )
      ),
    );
  }
}
