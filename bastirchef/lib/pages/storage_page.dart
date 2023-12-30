// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:bastirchef/resources/auth_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Storage extends StatefulWidget {
  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  var userData = {};
  bool isLoading = false;
  Map<String, dynamic> userStorage = {};

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

      userStorage = userData['storage'];
      
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
              child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children : [
                    Text("hello"),
                    Text("storage will be here"),
                    for(var item in userStorage.entries) Row(
                      children: <Widget>[
                        Text("Ingredient: " + item.key + "\nAmount: " + item.value.toString() + "\n"),
                        GestureDetector(
                          onTap: () {
                            userStorage.update(item.key, (existingValue) => existingValue + 1);
                            updateStorage();
                          },
                          child: Text("Add\t", style: TextStyle(color: Colors.green, fontSize: 12.0),)
                        ),
                        GestureDetector(
                          onTap: () {
                            userStorage.remove(item.key);
                            updateStorage();
                          },
                          child: Text("Remove", style: TextStyle(color: Colors.red, fontSize: 12.0),)
                        )
                      ],
                    )

                  ]))
          )
      ),
    );
  }
}
