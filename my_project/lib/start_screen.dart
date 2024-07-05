import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/login_page.dart';
import 'package:my_project/signup_page.dart';
import 'package:my_project/home_screen.dart';
import 'package:my_project/health_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StartScreen extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;

  const StartScreen({
    super.key,
    this.backgroundColor = const Color.fromARGB(255, 30, 39, 97),
    this.themeColor = const Color.fromARGB(255, 187, 210, 248),
  });

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      _navigateToLogin();
    } else {
      bool isValid = await _validateToken(token);
      if (isValid) {
        var now =
            DateTime.now().toUtc().add(Duration(hours: 5)); // Pakistan is UTC+5
        var ninePM = DateTime(now.year, now.month, now.day, 21, 0, 0);

        if (now.isAfter(ninePM)) {
          _navigateToSubmitHealthForm();
        } else {
          _navigateToHome();
        }
      } else {
        _navigateToStartScreen();
      }
    }
  }

  Future<bool> _validateToken(String token) async {
    final response = await http.post(
      Uri.parse('https://your-backend-url.com/validate-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Assuming your backend returns a JSON response with a boolean field 'isValid'
      final body = json.decode(response.body);
      return body['isValid'];
    } else {
      return false;
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage(
                themeColor: widget.themeColor,
                backgroundColor: widget.backgroundColor,
              )),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen(
                themeColor: widget.themeColor,
                backgroundColor: widget.backgroundColor,
              )),
    );
  }

  void _navigateToSubmitHealthForm() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SubmitHealthForm()),
    );
  }

  void _navigateToStartScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => StartScreen(
                themeColor: widget.themeColor,
                backgroundColor: widget.backgroundColor,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Center(
            child: ClipOval(
              child: Image.asset(
                'assets/images/start_screen_img.jpg',
                width: 350,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            'VizAvatar',
            style: TextStyle(
                fontFamily: 'RobotoSlab',
                color: widget.themeColor,
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () {
              _navigateToLogin();
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 10.0),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                widget.themeColor,
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignupPage(
                    themeColor: widget.themeColor,
                    backgroundColor: widget.backgroundColor,
                  ),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.fromLTRB(65.0, 10.0, 65.0, 10.0),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                widget.themeColor,
              ),
            ),
            child: const Text(
              "SignUp",
              style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
