// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:typed_data';

import 'package:bastirchef/pages/src/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bastirchef/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:bastirchef/resources/storage_methods.dart';
import 'src/button.dart'; // Ensure this import is correct for your CustomButton widget

class CreateRecipe extends StatefulWidget {
  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  var recipeData = {};
  var userData = {};
  List<Map<String, dynamic>> allIngredients = [];
  bool isLoading = false;
  List<dynamic> selectedIds = [];
  Uint8List? _file;

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
      var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

      userData = userSnap.data()!;

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('ingredients').get();
      allIngredients = querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();
      
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Map<int, String> getOptions() {
    Map<int, String> options = {};
    for(int i = 0; i < allIngredients.length; i++){
      options[i] = allIngredients[i]['name'];
    }
    return options;
  }

  shareRecipe() async {
    setState(() {
      isLoading = true;
    });
    String photoUrl = "";
    try {
      if (_file != null) {
        photoUrl = await StorageMethods().uploadImageToStorage('posts', _file!, false);
        print('Image uploaded successfully. URL: $photoUrl');
      } else {
        print('Error: _file is null.');
      }

      print("im here");

      Map<String, dynamic> map = {'unit': 'gr', 'amount': 1};
      Map<String, Map<String, dynamic>> ings = Map.fromIterable(
        selectedIds,
        key: (k) => k,
        value: (v) => map,
      );

      var recipe = {
        'recipeName': _titleTextController.text.toString(),
        'recipeText': _descriptionTextController.text.toString(),
        'comments': [],
        'reactions': {'delicios': 0, 'looksGood': 0, 'oghk': 0},
        'timeCreated': DateTime.now(),
        'ingredients': ings,
        'mainIngredients': mainIngredients,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'image': photoUrl,
      };

      await FirebaseFirestore.instance.collection('recipes').add(recipe);
      print('Recipe added successfully.');
          // Navigate to Profile page after successful share
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
    } catch (e, stackTrace) {
      print('Error sharing recipe: $e\n$stackTrace');
      // Handle the error or throw an exception
      // throw e;
    }

    setState(() {
      isLoading = false;
    });
  }

  void _addIngredient() {
    DropDownState(
      DropDown(
        buttonText: "Add",
        options: getOptions(),
        selectedOptions: [],
        selectedItems: (List<dynamic> selectedList) {
          setState(() {
            selectedIds = selectedList;
            print(selectedIds);
          });
          // Logic to add selected ingredients to the ingredients list
        },
        enableMultipleSelection: true,
      ),
    ).showModal(context);
  }

  final List<String> ingredients = [
    "Example Ingredient 1",
    "Example Ingredient 2"
  ];

  pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
  }

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select a Photo'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
  List<dynamic> mainIngredients = [];
  Column buildIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: selectedIds.map((ingredient) {
        return ListTile(
          title: Text(ingredient),
          trailing: Row(
            mainAxisSize: MainAxisSize.min, // To keep the row size to a minimum
            children: [
              Checkbox(
                value: mainIngredients.contains(ingredient),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      mainIngredients.add(ingredient);
                    } else {
                      mainIngredients.remove(ingredient);
                    }
                  });
                },
                activeColor: Colors.orange,
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    selectedIds.remove(ingredient);
                    mainIngredients.remove(ingredient); // Also remove from mainIngredients if it's there
                  });
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }



  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _descriptionTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF282828),
        leading: GestureDetector(
          onTap: () {
            setState(() {
              Navigator.pop(context);
            });
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Color(0xFFE3E3E3),
            size: 40,
          ),
        ),
        title: Text(
          "Create Recipe",
          style: TextStyle(
            color: Color(0xFFE3E3E3),
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_file != null) 
              Container(
                          height: 200, // Height for the recipe photo
                          width: double.infinity, // Full width of the container
                          decoration: BoxDecoration(
                            image: _file != null
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    alignment: FractionalOffset.topCenter,
                                    image: MemoryImage(_file!),
                                  )
                                : null, // Return null if _file is null
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                          ),
              ),      
            Padding(
              padding: EdgeInsets.only( top: 16, bottom: 16, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [      
                  // // Add photo button
                  // Center(
                  //   child: IconButton(
                  //     icon: Icon(Icons.photo_camera),
                  //     onPressed: () => _selectImage(context),
                  //   ),
                  // ),
            
                  TextField(
                    controller: _titleTextController,
                    decoration: InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Ingredients",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      CustomButton(
                        text: 'Add Ingredient',
                        onPressed: () {
                          setState(() {
                            // ingredients.add('New Ingredient');
                            _addIngredient();
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: buildIngredientsList(),
                    // Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: selectedIds
                    //       .map((ingredient) => Text(ingredient))
                    //       .toList(),
                    // ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _descriptionTextController,
                    decoration: InputDecoration(
                      labelText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'Share',
                    onPressed: () {
                      print('Share');
                      shareRecipe();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        
      ),

            floatingActionButton: FloatingActionButton(
        onPressed: () => _selectImage(context),
        backgroundColor: Color(0xFFD75912),
        child: Icon(Icons.photo_camera), // Sets the background color to orange
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Positions the button at the bottom right
    );
  }
}
