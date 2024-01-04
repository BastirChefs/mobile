import 'package:bastirchef/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:bastirchef/resources/auth_methods.dart';
import 'package:bastirchef/pages/login_screen.dart';
import 'package:bastirchef/pages/src/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _usernameTextController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

      // Check if fields are empty
    if (_emailTextController.text.isEmpty || _passwordTextController.text.isEmpty || _usernameTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }


    String res = await AuthMethods().signUpUser(
      email: _emailTextController.text, 
      password: _passwordTextController.text, 
      username: _usernameTextController.text,
      createdAt: DateTime.now(),
      favoriteRecipes: [],
      recipeLists: [],
      recipes: [],
      shopping_list: {},
      storage: {},
      recipeHistory: [],
      userImage: "https://firebasestorage.googleapis.com/v0/b/bastirchef-3aeef.appspot.com/o/posts%2Fdefaultphoto.jpg?alt=media&token=c24e0732-8886-44c6-9931-949e1fbf8c89");
    if (res == "success") {

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LogInScreen()
          ),
      );
    } else {
      // Parse the error message
      String errorMessage = res;
      if (res.contains(']')) {
        errorMessage = res.substring(res.indexOf(']') + 1).trim();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLogIn() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LogInScreen()));
  }

  @override
  Widget build(BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 1),
              Image.asset(
                "lib/pages/src/images/bastirChefLogo.png",
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _usernameTextController,
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _emailTextController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordTextController,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.orange),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,),) : const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.orange,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text("Do you already have an account? "),
                  ),
                  InkWell(
                    onTap: navigateToLogIn,
                    child: Container(
                      width: screenWidth * 0.5,
                      padding: const EdgeInsets.symmetric(vertical: 12,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.orange), // Orange border
                      ),
                      child: const Text(
                        "Log in", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange,),
                        textAlign: TextAlign.center,
                        ),
                    ),
                  ),



                ],
              ),
              Flexible(child: Container(), flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
