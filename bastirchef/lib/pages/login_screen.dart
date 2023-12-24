import 'package:bastirchef/navigation.dart';
import 'package:flutter/material.dart';
import 'package:bastirchef/resources/auth_methods.dart';
import 'package:bastirchef/pages/homepage.dart';
import 'package:bastirchef/pages/signup_screen.dart';
import 'package:bastirchef/pages/src/text_field_input.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().logInUser(email: _emailTextController.text, password: _passwordTextController.text);

    if(res == "success"){
      print("yey");
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Navigation()
          ),
        );
    } else {
      setState(() {
        _isLoading = false;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
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
              Flexible(child: Container(), flex: 1), // Reduced flex to move the signup button higher
              const SizedBox(height: 64),
              Image.asset(
                "lib/pages/src/images/bastirChefLogo.png", // Path to your image asset
                width: 100, // Adjust the size as needed
                height: 100,
              ),
              TextField(
                controller: _emailTextController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey), // Default border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.orange), // Border color when the field is focused
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordTextController,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.grey), // Default border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(color: Colors.orange), // Border color when the field is focused
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,),) : const Text('Log in'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)), // More rounded corners
                    color: Colors.orange, // Changed to orange
                  ),
                ),
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: navigateToSignUp,
                child: Container(
                  child: const Text("Sign up", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),),
                  padding: const EdgeInsets.symmetric(vertical: 12,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.orange), // Orange border
                  ),
                ),
              ),
              Flexible(child: Container(), flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}