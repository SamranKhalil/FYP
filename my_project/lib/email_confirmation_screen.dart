import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:my_project/signup_model.dart';

class EmailConfirmationScreen extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;
  final String email;

  const EmailConfirmationScreen({
    Key? key,
    required this.themeColor,
    required this.backgroundColor,
    required this.email,
  }) : super(key: key);

  @override
  _EmailConfirmationScreenState createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final TextEditingController _confirmationCodeController =
      TextEditingController();

  Future<void> _submitConfirmationCode() async {
    final String confirmationCode = _confirmationCodeController.text;
    final url = 'http://10.0.2.2:8000/user/confirm-email/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'confirmation_code': confirmationCode}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('gender', data['gender']);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              themeColor: widget.themeColor,
              backgroundColor: widget.backgroundColor,
            ),
          ),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        print('Error response: $errorResponse');
      }
    } catch (errorResponse) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${errorResponse.toString()}'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _resendConfirmationCode() async {
    final url = 'http://10.0.2.2:8000/user/resend-confirmation/';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({'email': widget.email}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Confirmation code sent successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to resend confirmation code'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 150),
              const Text(
                'Enter Confirmation Code',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Enter the confirmation code we sent you to ${widget.email}.',
                style: const TextStyle(
                  fontFamily: 'RobotoSlab',
                  fontSize: 18,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: _resendConfirmationCode,
                child: const Text(
                  'Resend Confirmation Code',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.lightBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _confirmationCodeController,
                  decoration: const InputDecoration(
                    hintText: 'Enter Confirmation Code',
                    hintStyle: TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitConfirmationCode,
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 15.0,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    widget.themeColor, // Use themeColor from widget
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
