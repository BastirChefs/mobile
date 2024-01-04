import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bastirchef/models/user.dart' as model;
import 'package:bastirchef/services/notification_service.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _notificationService = NotificationService();

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

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
    required Map storage,
    required Map shopping_list,
    required List recipeHistory,
    required String userImage,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print(cred.user!.uid);

        model.User user = model.User(
          username: username,
          //uid: cred.user!.uid,
          email: email,
          createdAt: DateTime.now(),
          favoriteRecipes: [],
          recipeLists: {},
          recipes: [],
          storage: {},
          shopping_list: {},
          recipeHistory: [],
          userImage: "https://firebasestorage.googleapis.com/v0/b/bastirchef-3aeef.appspot.com/o/posts%2Fdefaultphoto.jpg?alt=media&token=c24e0732-8886-44c6-9931-949e1fbf8c89"
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> logInUser({required String email, required String password}) async {
    String res = "Some error occurred";

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        _notificationService.initNotifications();
        res = "success";
      } on FirebaseAuthException catch (e) {
        print(e.message); // For debugging purposes
        res = "Incorrect credentials. Please try again.";
      } catch (err) {
        res = "An unexpected error occurred. Please try again later.";
      }
    } else {
      res = "Please fill all the fields.";
    }

    return res;
  }



  Future<void> signOut() async {
    await _auth.signOut();
  }
}
