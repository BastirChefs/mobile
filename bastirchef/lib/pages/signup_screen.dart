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

    String res = await AuthMethods().signUpUser(
      email: _emailTextController.text, 
      password: _passwordTextController.text, 
      username: _usernameTextController.text,
      createdAt: DateTime.now(),
      favoriteRecipes: [],
      recipeLists: [],
      recipes: [],
      storage: [],);
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Homepage()
          ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void navigateToLogIn() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LogInScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              TextFieldInput(textEditingController: _usernameTextController, hintText: 'Enter your username', textInputType: TextInputType.text,),
              const SizedBox( height: 10),
              TextFieldInput(textEditingController: _emailTextController, hintText: 'Enter your email', textInputType: TextInputType.emailAddress,),
              const SizedBox( height: 10),
              TextFieldInput(textEditingController: _passwordTextController, hintText: 'Enter your password', textInputType: TextInputType.text, isPass: true,),
              const SizedBox( height: 10),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,),) : const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder( 
                      borderRadius: BorderRadius.all(Radius.circular(4),),
                    ),
                    color: Colors.blue),
                ),
              ),
              const SizedBox( height: 24),
              Flexible(child: Container(), flex: 2),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Do you already have an account? "),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToLogIn,
                    child: Container(
                      child: const Text("Log in", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
                      padding: const EdgeInsets.symmetric(vertical: 8,),
                    ),
                  ),
                ],
              )
            ],

          )
      ),) 
    );
  }
}
