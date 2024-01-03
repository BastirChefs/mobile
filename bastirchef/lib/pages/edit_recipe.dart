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

class EditRecipe extends StatefulWidget {
  final String id;
  EditRecipe({Key? key, required this.id}) : super(key: key);
  @override
  State<EditRecipe> createState() => _EditRecipeState();
}

class _EditRecipeState extends State<EditRecipe> {
  var recipeData = {};
  var userData = {};
  List<Map<String, dynamic>> allIngredients = [];
  bool isLoading = false;
  List<String> selectedIds = [];
  Uint8List? _file;
  String photoUrl = "";

  //amount
  Map<String, TextEditingController> amountControllers = {};

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
      .doc(widget.id) // Use the passed ID
      .get();

      if (recipeSnap.exists) {
        recipeData = recipeSnap.data()!;
        _titleTextController.text = recipeData['recipeName'];
        _descriptionTextController.text = recipeData['recipeText'];
        photoUrl = recipeData['image'];
        recipeData['ingredients'].keys.forEach((key) => selectedIds.add(key));
        mainIngredients = recipeData['mainIngredients'];
        // Handle photo loading if needed
      }
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

      // Initialize amountControllers with ingredient amounts
      recipeData['ingredients'].forEach((key, value) {
        amountControllers[key] = TextEditingController(text: value['amount'].toString());
      });
      
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

  editRecipe() async {
    setState(() {
      isLoading = true;
    });
    try {
      String updatedPhotoUrl = "";
      if (_file != null) {
        updatedPhotoUrl = await StorageMethods().uploadImageToStorage('posts', _file!, false);
        print('Image uploaded successfully. URL: $photoUrl');
      } else {
        print('Error: _file is null.');
        updatedPhotoUrl = photoUrl;
      }

      print("im here");

      Map<String, Map<String, dynamic>> ings = {};
      for (var ingredient in selectedIds) {
        String amount = amountControllers[ingredient]?.text ?? '0';
        String unit = allIngredients.firstWhere(
            (element) => element['name'] == ingredient,
            orElse: () => {'unit': ''})['unit'];

        ings[ingredient] = {'unit': unit, 'amount': amount};
      }

      var recipe = {
        'recipeName': _titleTextController.text.toString(),
        'recipeText': _descriptionTextController.text.toString(),
        'comments': recipeData['comments'],
        'reactions': recipeData['reactions'],
        'timeCreated': DateTime.now(),
        'ingredients': ings,
        'mainIngredients': mainIngredients,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'image': updatedPhotoUrl,
      };

      await FirebaseFirestore.instance.collection('recipes').doc(widget.id).update(recipe);
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
        selectedOptions: selectedIds, // Now correctly typed as List<String>
        selectedItems: (List<dynamic> newSelectedList) {
          setState(() {
            // Append new selections to existing list without duplicates
            for (var ingredient in newSelectedList) {
              String ingredientString = ingredient as String; // Cast dynamic to String
              if (!selectedIds.contains(ingredientString)) {
                selectedIds.add(ingredientString);
              }
            }
          });
        },
        enableMultipleSelection: true,
      ),
    ).showModal(context);
  }


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
        // Create a new TextEditingController if it does not exist for this ingredient
        amountControllers.putIfAbsent(ingredient, () => TextEditingController());

        String unit = allIngredients.firstWhere(
            (element) => element['name'] == ingredient,
            orElse: () => {'unit': 'unknown'})['unit'];

        return ListTile(
          title: Row(
            children: [
              Expanded(
                child: Text(ingredient),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: amountControllers[ingredient],
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    suffixText: unit,
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
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
                    amountControllers.remove(ingredient); // Remove its controller
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
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('recipes').doc(widget.id).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator or placeholder while data is being fetched.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          // Handle the case where no data is available
          return Text('No data available');
        } else {
          // Data is available, update recipeData
          recipeData = snapshot.data!.data() as Map<String, dynamic>;
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
          "Edit Recipe",
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
            if(_file == null) Container(
              height: 200, 
              width: double.infinity,
              child: Image.network(
                      recipeData['image'],
                      fit: BoxFit.cover, // Adjust the fit based on your requirement
                    ),
            ) ,
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
                    text: 'Edit',
                    onPressed: () {
                      editRecipe();
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
  );
  }
}
