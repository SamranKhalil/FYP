import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_project/signup_page_gender.dart';
import 'package:my_project/signup_model.dart';

class SignupPageDob extends StatefulWidget {
  final Color themeColor;
  final SignupData signupData;

  const SignupPageDob(
      {Key? key, required this.themeColor, required this.signupData})
      : super(key: key);

  @override
  _SignupPageDobState createState() => _SignupPageDobState();
}

class _SignupPageDobState extends State<SignupPageDob> {
  DateTime? _selectedDate;

  bool get _isNextButtonEnabled => _selectedDate != null;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: GoogleFonts.roboto()),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'Enter your date of birth',
                style: GoogleFonts.robotoSlab(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _selectedDate == null
                      ? 'Select Date of Birth'
                      : 'Date of Birth: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: GoogleFonts.robotoSlab(),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'What should we call you?',
                style: GoogleFonts.robotoSlab(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: GoogleFonts.roboto(color: widget.themeColor),
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
                  style: GoogleFonts.roboto(),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isNextButtonEnabled
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignupPageGender(
                              themeColor: widget.themeColor,
                              signupData: SignupData(
                                email: widget.signupData.email,
                                password: widget.signupData.password,
                                username: '',
                                dob: _selectedDate,
                                gender: null,
                                height: 0,
                                weight: 0,
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
