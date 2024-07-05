import 'package:flutter/material.dart';
import 'package:my_project/signup_page_gender.dart';
import 'package:my_project/signup_model.dart';

class SignupPageDob extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;
  final SignupData signupData;

  const SignupPageDob({
    super.key,
    required this.themeColor,
    required this.backgroundColor,
    required this.signupData,
  });

  @override
  _SignupPageDobState createState() => _SignupPageDobState();
}

class _SignupPageDobState extends State<SignupPageDob> {
  DateTime? _selectedDate;
  TextEditingController _usernameController = TextEditingController();

  bool get _isNextButtonEnabled =>
      _selectedDate != null && _usernameController.text.isNotEmpty;

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
  void dispose() {
    _usernameController.dispose();
    super.dispose();
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Enter your date of birth',
                style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 20,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(widget.themeColor),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: widget.themeColor),
                    ),
                  ),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Select Date of Birth'
                      : 'Date of Birth: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: const TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'What should we call you?',
                style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 20,
                    color: Colors.white),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: Colors.white), // Text color
                  decoration: InputDecoration(
                    labelText: 'Username',
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
                  onChanged: (text) {
                    setState(() {});
                  },
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
                              backgroundColor: widget.backgroundColor,
                              signupData: SignupData(
                                email: widget.signupData.email,
                                password: widget.signupData.password,
                                username: _usernameController.text,
                                dob: _selectedDate!,
                                gender: '',
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
      ),
    );
  }
}
