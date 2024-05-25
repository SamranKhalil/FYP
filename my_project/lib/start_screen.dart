import 'package:flutter/material.dart';
import 'package:my_project/login_page.dart';
import 'package:my_project/signup_page.dart';

class StartScreen extends StatelessWidget {
  final Color themeColor;
  const StartScreen(
      {this.themeColor = const Color.fromARGB(160, 131, 0, 239), super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
          const Text(
            'VizAvatar',
            style: TextStyle(
              color: Color.fromARGB(160, 131, 0, 239),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginPage(themeColor: themeColor)),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                themeColor,
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                    builder: (context) => SignupPage(themeColor: themeColor)),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                themeColor,
              ),
            ),
            child: const Text(
              "SignUp",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
