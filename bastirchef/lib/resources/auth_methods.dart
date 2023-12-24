import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bastirchef/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required DateTime createdAt,
    required List favoriteRecipes,
    required List recipeLists,
    required List recipes,
    required List storage,
    required List recipeHistory,
  }) async {
    String res = "Some error occured";
    try {
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        print(cred.user!.uid);

        model.User user = model.User(
          username: username,
          //uid: cred.user!.uid,
          email: email,
          createdAt: DateTime.now(),
          favoriteRecipes: [],
          recipeLists: {},
          recipes: [],
          storage: [],
          recipeHistory: [],
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson(),);
        res = "success";
      }
    } catch(err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> logInUser({
    required String email,
    required String password
  }) async {
    String res = "Some error occured";

    
    if(email.isNotEmpty && password.isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "success";
      } catch(err) {
        res = "fail";
        print(res);
      }
    } else {
      res = "Please fill all fields";
    }
    
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}