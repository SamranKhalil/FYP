import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_project/home_screen.dart';
import 'package:my_project/signup_model.dart';

class SignupPageGender extends StatefulWidget {
  final Color themeColor;
  final SignupData signupData;

  const SignupPageGender({
    Key? key,
    required this.themeColor,
    required this.signupData,
  }) : super(key: key);

  @override
  _SignupPageGenderState createState() => _SignupPageGenderState();
}

class _SignupPageGenderState extends State<SignupPageGender> {
  String? _selectedGender;
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  bool _isLoading = false;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _isMounted = false;
    super.dispose();
  }

  bool get _isSubmitEnabled =>
      _selectedGender != null &&
      _heightController.text.isNotEmpty &&
      _weightController.text.isNotEmpty;

  int calculateAge(DateTime? dob) {
    if (dob == null) return 0;
    DateTime now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  Future<void> _submitForm() async {
    final String height = _heightController.text;
    final String weight = _weightController.text;

    if (_selectedGender == null || height.isEmpty || weight.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    if (_isMounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final int age = calculateAge(widget.signupData.dob);
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.2:8000/user/signup/'), // Replace with your computer's IP address
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.signupData.email,
          'password': widget.signupData.password,
          'username': widget.signupData.username,
          'age': age,
          'gender': _selectedGender,
          'height': int.parse(height),
          'weight': int.parse(weight),
        }),
      );

      if (_isMounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String token = responseData['token'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              themeColor: widget.themeColor,
              token: token,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: ${response.statusCode}')),
        );
      }
    } catch (error) {
      print('Error: $error');
      if (_isMounted) {
        setState(() {
          _isLoading = false;
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up', style: GoogleFonts.roboto()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Text(
              'Gender',
              style: GoogleFonts.robotoSlab(fontSize: 20),
            ),
            RadioListTile<String>(
              title: Text(
                'Male',
                style: GoogleFonts.robotoSlab(fontSize: 18),
              ),
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (value) {
                if (_isMounted) {
                  setState(() {
                    _selectedGender = value;
                  });
                }
              },
              activeColor: widget.themeColor,
              dense: true,
            ),
            RadioListTile<String>(
              title: Text(
                'Female',
                style: GoogleFonts.robotoSlab(fontSize: 18),
              ),
              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (value) {
                if (_isMounted) {
                  setState(() {
                    _selectedGender = value;
                  });
                }
              },
              activeColor: widget.themeColor,
              dense: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (Cm)',
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
            const SizedBox(height: 30),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (Kg)',
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
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isSubmitEnabled ? _submitForm : null,
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
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      'Submit',
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
    );
  }
}
