import 'package:flutter/material.dart';

class FoodBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

      height: MediaQuery.of(context).size.height / 6,
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.only(top: 20, bottom: 20, right: 30, left: 30),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10), // Margin around the container
      decoration: BoxDecoration(
        color: Color(0xFFD75912),
        borderRadius: BorderRadius.circular(35.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.7),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 7), // changes position of shadow
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
              color: Color(0xFFE3E3E3),
              fontSize: 30,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 10), // Add spacing between the texts
          Text(
            "What would you",
            style: TextStyle(
              color: Color(0xFFE3E3E3),
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}