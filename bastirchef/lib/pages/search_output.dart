// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bastirchef/pages/src/drop_down_text_field.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:flutter/material.dart';

class SearchOutput extends StatefulWidget {
  const SearchOutput({super.key});

  @override
    State<SearchOutput> createState() => _SearchOutputState();
}
  class _SearchOutputState extends State<SearchOutput> {
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
                            options: {1:"Tomato",2:"Patato",3:"Chicken",4:"Pasta",5:"Pesto Sauce",6:"Arrabiata Sauce",7:"Filler",8:"Filler",9:"Filler",10:"Filler",11:"Filler"},
                            selectedOptions: [2,3],
                            onChanged: (selectedIds) {
                              //setState(() => selectedIds);
                            },
                            multiple: true,
                        ),
                        )
                      ],
                    ),
                  ),
                    SizedBox(height: 10),
                    FoodBox(id: "x0KwRvsB0sHvGPZpieKe"),
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