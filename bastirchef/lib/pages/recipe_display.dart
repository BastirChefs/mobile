// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class RecipeDisplay extends StatefulWidget {
  const RecipeDisplay({super.key});

  @override
    State<RecipeDisplay> createState() => _RecipeDisplayState();
}

  class _RecipeDisplayState extends State<RecipeDisplay> {
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