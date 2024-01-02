// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecipeDisplay extends StatefulWidget {
  final String id;
  const RecipeDisplay({Key? key, required this.id}) : super(key: key);

  @override
  State<RecipeDisplay> createState() => _RecipeDisplayState();
}

class _RecipeDisplayState extends State<RecipeDisplay> {
  var recipeData = {};
  var userData = {};
  bool isLoading = false;
  TextEditingController commentController = TextEditingController();
  var username;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    commentController
        .dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;
      username = userData['username'];
      var recipeSnap = await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.id)
          .get();

      recipeData = recipeSnap.data()!;
      print(recipeData);
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  addToFav() async {
    setState(() {
      isLoading = true;
    });
    var favList = userData['favorite_recipes'];
    favList.add(widget.id);
    var currentLikes = recipeData['reactions']['delicios'];
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.id)
          .update({'reactions.delicios': currentLikes + 1});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'favorite_recipes': favList});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  addComment(comment) async {
    setState(() {
      isLoading = true;
    });
    List allComments = recipeData['comments'];
    try {
      Map commentMap = {
        'comment': comment,
        'createdAt': DateTime.now(),
        'userId': username,
        'userImage': userData['userImage'],
      };
      print(commentMap);
      allComments.add(commentMap);

      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(widget.id)
          .update({'comments': allComments});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  List checkMissingIngredients() {
    setState(() {
      isLoading = true;
    });
    List missingItems = [];
    var keyList = recipeData['ingredients'].keys;
    for (var keys in keyList) {
      var ingredient = recipeData['ingredients'][keys];
      if (userData['storage'][keys] == null) {
        var key = ingredient;
        var value = ingredient['amount'];
        Map item = {key: value};
        missingItems.add(item);
      } else if (userData['storage'][keys] < ingredient['amount']) {
        var key = ingredient;
        var value = ingredient['amount'] - userData['storage'][keys];
        Map item = {key: value};
        missingItems.add(item);
      }
    }
    setState(() {
      isLoading = false;
    });
    print(missingItems);
    return missingItems;
  }

  addToList(listName) async {
    setState(() {
      isLoading = true;
    });
    try {
      List addedList = userData['recipe_list'][listName];
      addedList.add(widget.id);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'recipe_list.$listName': addedList});
    } catch (e) {
      print(e);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            List missingItems = checkMissingIngredients();
            if (missingItems.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("All Set!"),
                    content: Text(
                        "You don't have any missing ingredients! You can start making the recipe."),
                    actions: <Widget>[
                      TextButton(
                        child: Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Missing Ingredients"),
                    content: Container(
                      width: double.maxFinite, // Make the dialog wider
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                              "Do you want to add these ingredients to your shopping list?"),
                          SizedBox(height: 16),
                          SingleChildScrollView(
                            child: ListBody(
                              children: missingItems.map((item) {
                                return Text(
                                    "•    ${item.keys.first}: ${item.values.first}");
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text("Add to Shopping List"),
                        onPressed: () {
                          // Add functionality to add items to shopping list
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: Text("Cancel"),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },

          icon: Icon(Icons.question_mark_rounded,
              color: Colors.white), // White icon
          label: Text('Check My Storage',
              style: TextStyle(color: Colors.white)), // White text
          backgroundColor: Color(0xFFD75912), // Custom color
          elevation: 5.0, // Adds a slight shadow for depth
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(15)), // Rounded corners for a softer look
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation
            .endFloat, // Position at the bottom right
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: 200, // Height for the recipe photo
                          width: double.infinity, // Full width of the container
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(recipeData['image']), // Path to your image asset
                              fit: BoxFit
                                  .cover, // This will cover the entire space of the container
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                          ),
                        ),
                        Container(
                          height: 50, // Height of the bar
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(
                                0.5), // Semi-transparent black color
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.add,
                                    color: Colors
                                        .white), // Add to recipe list icon
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String selectedListName = userData[
                                              'recipe_list']
                                          .keys
                                          .first; // Default to the first list
                                      return StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Text(
                                                    "Which recipe list would you like to add this recipe to?"),
                                              ),
                                              for (String listName
                                                  in userData['recipe_list']
                                                      .keys)
                                                ListTile(
                                                  title: Text(listName),
                                                  leading: Radio(
                                                    value: listName,
                                                    groupValue:
                                                        selectedListName,
                                                    onChanged: (String? value) {
                                                      if (value != null) {
                                                        setState(() =>
                                                            selectedListName =
                                                                value);
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ElevatedButton(
                                                child: Text("Add"),
                                                onPressed: () {
                                                  Navigator.pop(
                                                      context); // Close the bottom sheet
                                                  addToList(
                                                      selectedListName); // Call the function with selected list name
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.star,
                                        color: Colors
                                            .white), // Star (Favorite) icon
                                    onPressed: () {
                                      addToFav(); // Call addToFav function on press
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.comment,
                                        color: Colors.white), // Comment icon
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Column(
                                            children: [
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      recipeData['comments']
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var comment =
                                                        recipeData['comments']
                                                            [index];
                                                    return ListTile(
                                                      leading: comment[
                                                                  'userImage'] !=
                                                              ''
                                                          ? CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      comment[
                                                                          'userImage']))
                                                          : CircleAvatar(
                                                              child: Icon(Icons
                                                                  .person)),
                                                      title: Text(comment[
                                                          'comment']),
                                                      subtitle: Text(comment['userId'].toString()),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Divider(),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextField(
                                                        controller:
                                                            commentController,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              'Add a comment...',
                                                          border:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.send),
                                                      onPressed: () {
                                                        if (commentController
                                                            .text.isNotEmpty) {
                                                          addComment(
                                                              commentController
                                                                  .text);
                                                          commentController
                                                              .clear(); // Clear the text field after sending the comment
                                                        } 
                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(recipeData['recipeName'],
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Ingredients",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      width: MediaQuery.of(context).size.width -
                          16, // Full width minus horizontal margins
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Grey color for the container
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...recipeData['ingredients']
                              .entries
                              .map((ingredient) {
                            return Text(
                                "•    ${ingredient.key}: ${ingredient.value['amount']} ${ingredient.value['unit']}");
                          }).toList(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Description",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.all(8.0),
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      width: MediaQuery.of(context).size.width - 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Grey color for the container
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(recipeData['recipeText']),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
