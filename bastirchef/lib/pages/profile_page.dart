// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors, prefer_interpolation_to_compose_strings

import 'dart:typed_data';
import 'package:bastirchef/pages/login_screen.dart';
import 'package:bastirchef/pages/recipe_list.dart';
import 'package:bastirchef/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bastirchef/pages/create_recipe.dart';
import 'package:bastirchef/pages/recipes_by_me.dart';
import 'package:flutter/material.dart';
import 'package:bastirchef/resources/storage_methods.dart';
import 'package:image_picker/image_picker.dart';
import 'src/button.dart';
import 'storage_page.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userData = {};
  bool isLoading = false;
  List<String> recipeListsNames = [];
  String newListName = "";
  TextEditingController newListNameController = TextEditingController();
  //suggest
  String? selectedUnit;
  String ingredientName = '';
  final List<String> units = ['gr', 'kg', 'ml', 'liter', 'cl',  'pcs']; // Example units
  TextEditingController ingredientNameController = TextEditingController();
  List<Map<String, dynamic>> allIngredients = [];
  String errorMessage = '';
  //suggest end
  Uint8List? _file;
  String photoUrl = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    newListNameController.dispose();
    super.dispose();
  }

  Future<void> _getIngredients() async {
    try {
      // Fetch ingredients
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('ingredients').get();
      setState(() {
        allIngredients = querySnapshot.docs
            .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  sendSuggestion() async {
    setState(() {
      isLoading = true;
    });
    try {
      var ingredient = {
        'name': ingredientNameController.text.toString(),
        'unit': selectedUnit,
        'isVerified': false,
      };

      await FirebaseFirestore.instance
          .collection('ingredients')
          .add(ingredient);
      print('Ingredient suggested successfully.');
      // Navigate to Profile page after successful share
    } catch (e, stackTrace) {
      print('Error sending suggestion: $e\n$stackTrace');
      // Handle the error or throw an exception
      // throw e;
    }

    setState(() {
      isLoading = false;
    });
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
      print(userData);

      if (userData.containsKey('recipe_list') &&
          userData['recipe_list'] is Map<String, dynamic>) {
        recipeListsNames = userData['recipe_list'].keys.toList();
        print(recipeListsNames);
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
    updateRecipeList();
    setState(() {
      isLoading = false;
    });
  }

  removeList(index) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'recipe_list.$index': FieldValue.delete()});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  updateRecipeList() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'recipe_list.$newListName': [],
      });

      setState(() {
        recipeListsNames.add(newListName);
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
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
                  updateProfilePic();
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
                  updateProfilePic();
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

  updateProfilePic() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (_file != null) {
        photoUrl =
            await StorageMethods().uploadImageToStorage('posts', _file!, false);
        print('Image uploaded successfully. URL: $photoUrl');
      } else {
        print('Error: _file is null.');
      }
      print("trying to update pp");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'userImage': photoUrl,
      });
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
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator or placeholder while data is being fetched
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          // Handle case where document doesn't exist
          return Text('Recipe Not Found');
        } else {
          // Data has been successfully fetched
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Color(0xFFE3E3E3),
              appBar: AppBar(
                backgroundColor: Color(0xFF282828),
                leading: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Color(0xFFE3E3E3),
                  size: 40,
                ),
                title: Text(
                  "Profile Page",
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
                    //1st box: profile photo, username label, username
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                userData['username'],
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 40.0,
                                backgroundImage: NetworkImage(
                                  userData['userImage'],
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _selectImage(context);
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Change Photo',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(Icons.edit),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    //2nd box: create recipe, recipe created by me,my storage
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Create Recipe',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CreateRecipe()),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10), // Space between buttons
                              Expanded(
                                child: CustomButton(
                                  text: 'Storage',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Storage()),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10), // Space between button rows
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'Recipes by Me',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RecipesByMe()),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 10), // Space between buttons
                              Expanded(
                                child: CustomButton(
                                  text: 'Suggest Ingredient',
                                  onPressed: () {
                                    selectedUnit = null;
                                    ingredientNameController.clear();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          // Add StatefulBuilder here
                                          builder: (context, setState) {
                                            // 'setState' inside StatefulBuilder
                                            return AlertDialog(
                                              title: Text('Suggest Ingredient'),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    TextField(
                                                      controller:
                                                          ingredientNameController,
                                                      decoration: InputDecoration(
                                                          hintText:
                                                              "Enter ingredient name"),
                                                    ),
                                                    SizedBox(height: 20),
                                                    DropdownButton<String>(
                                                      value: selectedUnit,
                                                      hint: Text("Select Unit"),
                                                      isExpanded: true,
                                                      items: units
                                                          .map((String unit) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: unit,
                                                          child: Text(unit),
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          // Call setState to update the UI
                                                          selectedUnit =
                                                              newValue;
                                                        });
                                                      },
                                                    ),
                                                    if (errorMessage.isNotEmpty)
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: Text(
                                                            errorMessage,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .red)),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    errorMessage = "";
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Submit'),
                                                  onPressed: () {
                                                    _getIngredients();
                                                    if (selectedUnit != null &&
                                                        ingredientNameController
                                                            .text.isNotEmpty) {
                                                      print(
                                                          'Ingredient: ${ingredientNameController.text}, Unit: $selectedUnit');
                                                      sendSuggestion();
                                                      errorMessage = "";
                                                      Navigator.of(context)
                                                          .pop();
                                                    } else {
                                                      setState(() {
                                                        errorMessage =
                                                            'Please select a unit and enter an ingredient name.';
                                                      });
                                                    }
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
                              )
                            ],
                          ),
                        ],
                      ),
                    ),

                    //3rd box: My Recipe Lists with Add button
                    SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'My Recipe Lists',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("New Recipe List"),
                                          content: TextField(
                                            controller: newListNameController,
                                            decoration: InputDecoration(
                                                hintText: "Enter List Name"),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Add",
                                                  style: TextStyle(
                                                      color:
                                                          Color(0xFFD75912))),
                                              onPressed: () {
                                                newListName =
                                                    newListNameController.text;
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                                updateRecipeList();
                                                newListNameController
                                                    .clear(); // Clear the text field
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 24.0,
                                    color: Color(
                                        0xFFD75912), // Orange color for the icon
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey, // Set the border color
                                  width: 2.0, // Set the border width
                                ),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: recipeListsNames.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    title: Text(
                                      recipeListsNames[index],
                                      style: TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          removeList(recipeListsNames[index]);
                                          recipeListsNames.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                    onTap: () {
                                      print(
                                          recipeListsNames[index] + "clicked");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => RecipeList(
                                            recipeListName: recipeListsNames[
                                                index], // Pass the recipe list name here
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //4th box: signout
                    Container(
                      padding: EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () async {
                          await AuthMethods().signOut();
                          if (context.mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const LogInScreen(),
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.exit_to_app,
                              color: Colors.red,
                              size: 24.0,
                            ),
                            SizedBox(width: 16.0),
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
