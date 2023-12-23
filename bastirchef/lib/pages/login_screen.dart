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
            builder: (context) => Homepage()
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
              Flexible(child: Container(), flex: 2),
              const SizedBox(height: 64),
              TextFieldInput(textEditingController: _emailTextController, hintText: 'Enter your email', textInputType: TextInputType.emailAddress,),
              const SizedBox( height: 24),
              TextFieldInput(textEditingController: _passwordTextController, hintText: 'Enter your password', textInputType: TextInputType.text, isPass: true,),
              const SizedBox( height: 24),
              InkWell(
                onTap: loginUser,
                child: Container(
                  child: _isLoading ? const Center(child: CircularProgressIndicator(color: Colors.white,),) : const Text('Log in'),
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
                    child: const Text("Don't have an account? "),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToSignUp,
                    child: Container(
                      child: const Text("Sign up", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),),
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
