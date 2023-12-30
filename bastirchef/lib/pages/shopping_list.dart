import 'package:bastirchef/firebase_options.dart';
import 'package:bastirchef/pages/src/food_box.dart';
import 'package:bastirchef/pages/storage_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
              child: Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children : [
                    Text("hello"),
                    Text("shopping items will be added here"),
                        for(var item in items.entries) Row(
                      children: <Widget>[
                        Text("Ingredient: " + item.key + "\nAmount: " + item.value.toString() + "\n"),
                        GestureDetector(
                          onTap: () {
                            items.remove(item.key);
                            updateList();
                            updateStorage(item.key, item.value);
                          },
                          child: Text("Buy\t", style: TextStyle(color: Colors.green, fontSize: 12.0),)
                        ),
                        GestureDetector(
                          onTap: () {
                            items.remove(item.key);
                            updateList();
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
