// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors

import 'package:bastirchef/pages/src/drop_down.dart';
import 'package:flutter/material.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:bastirchef/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'src/item_box.dart';
import 'src/drop_down_text_field.dart';
import 'src/button.dart';

class Storage extends StatefulWidget {
  @override
  State<Storage> createState() => _StorageState();
}


class _StorageState extends State<Storage> {
  var userData = {};
  List<Map<String, dynamic>> allIngredients = [];
  bool isLoading = false;
  List<dynamic> selectedIds = [];
  Map<String, dynamic> userStorage = {};

  @override
  void initState() {
    super.initState();
    _getIngredients();
    getStorageData();
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

          // Show a dialog to input the amount if an ingredient is selected
          if (selectedList.isNotEmpty) {
            _showAmountDialog(context);
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }

  void _showAmountDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Amount'),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,

            decoration: InputDecoration(
              hintText: 'Enter the amount',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Perform actions with the entered amount
                if (amountController.text.isNotEmpty) {
                  // Call your addToStorage function passing the ingredient and amount
                  print(selectedIds[0]);
                  addToStorage( allIngredients[selectedIds[0]]['name'], int.tryParse(amountController.text) ?? 0);
                }
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  getStorageData() async {
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

      userStorage = userData['storage'];

    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  addToStorage(name, amount) async {
    setState(() {
      isLoading = true;
    });
    try {
      print(userData);
      userStorage = userData['storage'];

      if(userStorage[name] != null){
        userStorage[name] = userStorage[name] + amount;
      }else{
        userStorage[name] = amount;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'storage': userStorage});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  updateStorage() async {
    setState(() {
      isLoading = true;
    });
    try {
      print(userData);
      userStorage = userData['storage'];

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'storage': userStorage});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
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

  Map<int, String> getOptions() {
    Map<int, String> options = {};
    print(allIngredients.length);
    for (int i = 0; i < allIngredients.length; i++) {
      options[i] = allIngredients[i]['name'].toString();
    }
    print("options: ");
    print(options);
    return options;
  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
              "Storage",
              style: TextStyle(
                color: Color(0xFFE3E3E3),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          body: SingleChildScrollView(
              child: Center(child: Container(
                  margin: EdgeInsets.only(top: 50, right: 20, left: 20),
                  padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children : [
                    for(var item in userStorage.entries)
                      Container(
                        margin: EdgeInsets.all(8.0), // Example margin for spacing
                        padding: EdgeInsets.all(8.0), // Example padding for inner content
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12), // Example border
                          borderRadius: BorderRadius.circular(10.0), // Example border radius
                          color: Color(0xFFD9D9D9),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: ItemBox(ingredientName: item.key, amount: item.value),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                userStorage.remove(item.key);
                                updateStorage();
                              },
                              child: Icon(
                                Icons.delete_outline_outlined, // Replace this with the desired icon
                                color: Colors.red, // Set the color of the icon
                                size: 24, // Set the size of the icon
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFE3E3E3),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: CustomButton(
                        text: 'Add Ingredient',
                        onPressed: () {
                          setState(() {
                            // ingredients.add('New Ingredient');
                            _addIngredient();

                          });
                        },
                      ),
                    )
                  ])))
          )
      ),
    );
  }
}
