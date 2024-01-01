import 'package:flutter/material.dart';

class ItemBox extends StatelessWidget {
  final String ingredientName;
  final int amount;

  const ItemBox({
    Key? key,
    required this.ingredientName,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    "${ingredientName.substring(0, 1).toUpperCase()}${ingredientName.substring(1).toLowerCase()}",
                    style: TextStyle(color: Colors.black), // Change the color as needed
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 100), // Set left padding for the second Text
                    child: Text(
                      "$amount",
                      style: TextStyle(color: Colors.black), // Change the color as needed
                    ),
                  ),
                ],
              )

            ],
          ),
        ),

      ],
    );
  }
}
