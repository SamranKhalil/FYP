import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_project/signup_page_dob.dart';

class SignupPage extends StatelessWidget {
  final Color themeColor;

  const SignupPage({super.key, required this.themeColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: GoogleFonts.roboto()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'Let\'s Get Started',
                style: GoogleFonts.robotoSlab(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Provide us with a working email',
                style: GoogleFonts.robotoSlab(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: GoogleFonts.roboto(color: themeColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: themeColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: GoogleFonts.roboto(),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Set a Password',
                style: GoogleFonts.robotoSlab(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: GoogleFonts.roboto(color: themeColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: themeColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                  ),
                  style: GoogleFonts.roboto(),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          SignupPageDob(themeColor: themeColor),
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
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: Text(
                  'Next',
                  style: GoogleFonts.robotoSlab(
                    color: Colors.white,
                    fontSize: 20,
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
