import 'package:flutter/material.dart';
import 'package:my_project/signup_page_dob.dart';
import 'package:my_project/signup_model.dart';

class SignupPage extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;

  const SignupPage({
    super.key,
    required this.themeColor,
    required this.backgroundColor,
  });

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isNextButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      _isNextButtonEnabled = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: const Text('Sign Up',
            style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white)),
        backgroundColor: widget.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Let\'s Get Started',
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Provide us with a working email',
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(
                      fontFamily: 'RobotoSlab', color: widget.themeColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: widget.themeColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                onChanged: (_) => _validateFields(),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Set a Password',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                      fontFamily: 'RobotoSlab', color: widget.themeColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: widget.themeColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
                onChanged: (_) => _validateFields(),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isNextButtonEnabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPageDob(
                            themeColor: widget.themeColor,
                            backgroundColor: widget.backgroundColor,
                            signupData: SignupData(
                              email: _emailController.text,
                              password: _passwordController.text,
                              username: '',
                              dob: null,
                              gender: null,
                              height: 0,
                              weight: 0,
                              age: 0,
                              prevalentStroke: false,
                              prevalentHypertension: false,
                              diabetes: false,
                              currentSmoker: false,
                            ),
                          ),
                        ),
                      );
                    }
                  : null,
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 10.0),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  widget.themeColor,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
