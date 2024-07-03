import 'package:flutter/material.dart';
import 'package:my_project/login_page.dart';
import 'package:my_project/signup_page.dart';

class StartScreen extends StatelessWidget {
  final Color themeColor;
  final Color backgroundColor;

  const StartScreen({
    super.key,
    this.backgroundColor = const Color.fromARGB(255, 30, 39, 97),
    this.themeColor = const Color.fromARGB(255, 187, 210, 248),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                color: themeColor,
                fontSize: 40,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(
                    themeColor: themeColor,
                    backgroundColor: backgroundColor,
                  ),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.fromLTRB(70.0, 10.0, 70.0, 10.0),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                themeColor,
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
                    themeColor: themeColor,
                    backgroundColor: backgroundColor,
                  ),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.fromLTRB(65.0, 10.0, 65.0, 10.0),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                themeColor,
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
