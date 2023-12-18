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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120, // Adjust the width of the image container
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            // Replace this with your image widget
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15), // Same radius as the container decoration
              child: Image.asset(
                "lib/pages/src/images/pizza.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 20), // Add spacing between the texts
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Food Name",
                style: TextStyle(
                  color: Color(0xFFE3E3E3),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 10),
              Row(children:[
                Icon(Icons.favorite_border_outlined,
                color:Color(0xFFE3E3E3) ),
                SizedBox(width: 5),
                Text("2,3k",
                style: TextStyle(color: Color(0xFFE3E3E3))),
                SizedBox(width: 17),
                Icon(Icons.mode_comment_outlined,
                    color:Color(0xFFE3E3E3) ),

                SizedBox(width: 5),
                Text("2,3k",
                    style: TextStyle(color: Color(0xFFE3E3E3)))
              ])
            ]
          )

        ],
      ),
    );
  }
}