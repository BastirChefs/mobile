import 'package:bastirchef/pages/recipe_display.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FoodBox extends StatefulWidget {
  final String id;
  const FoodBox({Key? key, required this.id}) : super(key:key);
  @override
  State<FoodBox> createState() => _FoodBoxState();
}

class _FoodBoxState extends State<FoodBox> {
  var recipeData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var recipeSnap = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.id)
          .get();

      recipeData = recipeSnap.data()!;
      print(recipeData);
      setState(() {});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('recipes').doc(widget.id).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator or placeholder while data is being fetched
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          // Handle case where document doesn't exist
          return Container();
        } else {
          // Data has been successfully fetched
          var recipeData = snapshot.data!.data() as Map<String, dynamic>;

          return InkWell( // Wrap with InkWell for tap functionality
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => RecipeDisplay(id: widget.id), // Navigate to RecipeDisplay page
                ),
              );
            },
          
            child: Container(

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
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      recipeData['image'],
                      fit: BoxFit.cover, // Adjust the fit based on your requirement
                    ),
                  ),
                ),
                SizedBox(width: 20), // Add spacing between the texts
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                    width: 150, // Adjust the width of the image container
                    height: 55,
                      child: Text(
                        recipeData['recipeName'] ?? 'Recipe Name Not Available',
                        maxLines: 2, // Set maximum lines to 2
                        overflow: TextOverflow.ellipsis, // Truncate text with ellipsis if it exceeds 2 lines
                        softWrap: true, // Enable wrapping of text onto the next line
                        style: TextStyle(
                          color: Color(0xFFE3E3E3),
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                    ),

                    SizedBox(height: 10),
                    Row(children:[
                      Icon(Icons.star_border_outlined,
                      color:Color(0xFFE3E3E3) ),
                      SizedBox(width: 5),
                      Text(recipeData['reactions']['delicios'].toString(),
                      style: TextStyle(color: Color(0xFFE3E3E3))),
                      SizedBox(width: 17),
                      Icon(Icons.mode_comment_outlined,
                          color:Color(0xFFE3E3E3) ),

                      SizedBox(width: 5),
                      Text(recipeData['comments'].length.toString(),
                          style: TextStyle(color: Color(0xFFE3E3E3)))
                    ])
                  ]
                )

              ],
            ),
          )
          );
        }
      },
    );
  }
}