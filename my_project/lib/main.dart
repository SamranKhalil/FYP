import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/start_screen.dart';
import 'package:my_project/home_screen.dart';
import 'package:my_project/health_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      _navigateToStartScreen();
    } else {
      bool isValid = await _validateToken(token);
      if (isValid) {
        var now = DateTime.now().toUtc().add(Duration(hours: 5));
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
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/user/is-user-login'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['message'] == 'Token is valid';
    } else {
      return false;
    }
  }

  void _navigateToStartScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const StartScreen(
                themeColor: Color.fromARGB(255, 187, 210, 248),
                backgroundColor: Color.fromARGB(255, 30, 39, 97),
              )),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const HomeScreen(
                themeColor: Color.fromARGB(255, 187, 210, 248),
                backgroundColor: Color.fromARGB(255, 30, 39, 97),
              )),
    );
  }

  void _navigateToSubmitHealthForm() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SubmitHealthForm()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 30, 39, 97),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
