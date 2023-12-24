import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  //final String uid;
  final String username;
  final DateTime createdAt;
  final List favoriteRecipes;
  final Map recipeLists;
  final List recipes;
  final Map storage;
  final List recipeHistory;


  const User({
    required this.username,
    //required this.uid,
    required this.email,
    required this.createdAt,
    required this.favoriteRecipes,
    required this.recipeLists,
    required this.recipes,
    required this.storage,
    required this.recipeHistory,
  });

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      //uid: snapshot["uid"],
      email: snapshot["email"],
      createdAt: snapshot["created_at"],
      favoriteRecipes: snapshot["favorite_recipes"],
      recipeLists: snapshot["recipe_list"],
      recipes: snapshot["recipes"],
      storage: snapshot["storage"],
      recipeHistory: snapshot["recipeHistory"],
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    //"uid": uid,
    "email": email,
    "created_at": createdAt,
    "favorite_recipes": favoriteRecipes,
    "recipe_list": recipeLists,
    "recipes": recipes,
    "storage": storage,
    "recipeHistory": recipeHistory,
  };
}