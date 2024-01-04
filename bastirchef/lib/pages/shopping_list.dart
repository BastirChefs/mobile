import 'package:bastirchef/firebase_options.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:bastirchef/pages/storage_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'src/item_box.dart';



class ShoppingList extends StatefulWidget {

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  var userData = {};
  bool isLoading = false;
  Map<String, dynamic> items = {};

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
      print(userData);
      
      if (userData.containsKey('shopping_list') && userData['shopping_list'] is Map<String, dynamic>) {
        items = userData['shopping_list'];
        print(items);
      }
      setState(() {});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  deleteList() async {
    setState(() {
      isLoading = true;
    });
    items = {};
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'shopping_list': items});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  updateList () async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'shopping_list': items});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  updateStorage(key, value) async {
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
      var storage = userData['storage'];
      print(storage);
      
      if (userData.containsKey('storage')) {        
        if(storage[key] != null){
          storage.update(key, (existingValue) => existingValue + value);
        } else {
          storage[key] = value;
        }
        print(storage);
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'shopping_list': items, 'storage': storage});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF282828),
            leading: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFFE3E3E3),
              size: 40,
            ),
            title: Text(
              "Shopping List",
              style: TextStyle(
                color: Color(0xFFE3E3E3),
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 50, right: 20, left: 20),
                padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    for (var item in items.entries)
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
                            GestureDetector(
                              onTap: () {
                                items.remove(item.key);
                                updateList();
                                updateStorage(item.key, item.value);
                              },
                              child: Icon(
                                Icons.add_to_photos_rounded, // Replace this with the desired icon
                                color: Colors.green, // Set the color of the icon
                                size: 24, // Set the size of the icon
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                items.remove(item.key);
                                updateList();
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
                    GestureDetector(
                      onTap: () {
                        updateList();
                      },
                      child: Icon(
                        Icons.add_rounded, // Replace this with the desired icon
                        color: Color(0xFFD75912), // Set the color of the icon
                        size: 60, // Set the size of the icon

                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        deleteList();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end, // Aligns content to the end (right)
                        children: [
                          Spacer(), // Takes up remaining space to push the icon to the right
                          Padding(
                            padding: EdgeInsets.all(8.0), // Add padding around the icon
                            child: Icon(
                              Icons.delete,
                              color: Color(0xFFD75912),
                              size: 60,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )


      );
  }
}
