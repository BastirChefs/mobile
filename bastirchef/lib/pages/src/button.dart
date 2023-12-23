import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  CustomButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white, // Text color
          fontSize: 16.0, // Text font size
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Color(0xFFD75912), // Background color
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 3.0), // Button padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Button border radius
        ),
      ),
    );
  }
}
