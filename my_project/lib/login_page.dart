import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_project/home_screen.dart';

class LoginPage extends StatefulWidget {
  final Color themeColor;
  const LoginPage({super.key, required this.themeColor});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String token = responseData['token'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              themeColor: widget.themeColor,
              token: token,
            ),
          ),
        );
      } else {
        String errorMessage;
        if (response.statusCode == 401) {
          errorMessage = 'Invalid credentials. Please try again.';
        } else {
          errorMessage = 'Login failed. Please try again later.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login', style: TextStyle(fontFamily: 'RobotoSlab')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome Back',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: widget.themeColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: widget.themeColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 10.0),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(
                  widget.themeColor,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Login',
                      style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
