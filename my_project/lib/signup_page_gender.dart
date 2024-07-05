import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_project/email_confirmation_screen.dart';
import 'package:my_project/signup_model.dart';

class SignupPageGender extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;
  final SignupData signupData;

  const SignupPageGender({
    Key? key,
    required this.themeColor,
    required this.backgroundColor,
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
  bool? _prevalentStroke;
  bool? _prevalentHypertension;
  bool? _diabetes;
  bool _currentSmoker = false;

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
      _weightController.text.isNotEmpty &&
      _prevalentStroke != null &&
      _prevalentHypertension != null &&
      _diabetes != null;

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

    if (_selectedGender == null ||
        height.isEmpty ||
        weight.isEmpty ||
        _prevalentStroke == null ||
        _prevalentHypertension == null ||
        _diabetes == null) {
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
      final String formattedDob =
          DateFormat('yyyy-MM-dd').format(widget.signupData.dob!);
      final int age = calculateAge(widget.signupData.dob);
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/user/signup/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': widget.signupData.email,
          'password': widget.signupData.password,
          'username': widget.signupData.username,
          'age': age,
          'dob': formattedDob,
          'gender': _selectedGender,
          'height': int.parse(height),
          'weight': int.parse(weight),
          'prevalentStroke': _prevalentStroke,
          'prevalentHypertension': _prevalentHypertension,
          'diabetes': _diabetes,
          'currentSmoker': _currentSmoker,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (_isMounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailConfirmationScreen(
              themeColor: widget.themeColor,
              backgroundColor: widget.backgroundColor,
              email: widget.signupData.email,
            ),
          ),
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        print('Error response: $errorResponse');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Submission failed: ${response.statusCode} - ${errorResponse['detail'] ?? 'Unknown error'}',
            ),
          ),
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
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(fontFamily: 'RobotoSlab', color: Colors.white),
        ),
        backgroundColor: widget.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  RadioListTile<String>(
                    title: const Text(
                      'Male',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 18,
                        color: Colors.white,
                      ),
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
                    title: const Text(
                      'Female',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        fontSize: 18,
                        color: Colors.white,
                      ),
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
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Do you have prevalent stroke?',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Yes',
                  groupValue: _prevalentStroke == true ? 'Yes' : 'No',
                  onChanged: (value) {
                    if (_isMounted) {
                      setState(() {
                        _prevalentStroke = value == 'Yes';
                      });
                    }
                  },
                  activeColor: widget.themeColor,
                ),
                const Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Radio<String>(
                  value: 'No',
                  groupValue: _prevalentStroke == false ? 'No' : 'Yes',
                  onChanged: (value) {
                    if (_isMounted) {
                      setState(() {
                        _prevalentStroke = value == 'Yes';
                      });
                    }
                  },
                  activeColor: widget.themeColor,
                ),
                const Text(
                  'No',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Do you have prevalent hypertension?',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Yes',
                  groupValue: _prevalentHypertension == true ? 'Yes' : 'No',
                  onChanged: (value) {
                    if (_isMounted) {
                      setState(() {
                        _prevalentHypertension = value == 'Yes';
                      });
                    }
                  },
                  activeColor: widget.themeColor,
                ),
                const Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Radio<String>(
                  value: 'No',
                  groupValue: _prevalentHypertension == false ? 'No' : 'Yes',
                  onChanged: (value) {
                    if (_isMounted) {
                      setState(() {
                        _prevalentHypertension = value == 'Yes';
                      });
                    }
                  },
                  activeColor: widget.themeColor,
                ),
                const Text(
                  'No',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Do you have diabetes?',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Yes',
                  groupValue: _diabetes == true ? 'Yes' : 'No',
                  onChanged: (value) {
                    if (_isMounted) {
                      setState(() {
                        _diabetes = value == 'Yes';
                      });
                    }
                  },
                  activeColor: widget.themeColor,
                ),
                const Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Radio<String>(
                  value: 'No',
                  groupValue: _diabetes == false ? 'No' : 'Yes',
                  onChanged: (value) {
                    if (_isMounted) {
                      setState(() {
                        _diabetes = value == 'Yes';
                      });
                    }
                  },
                  activeColor: widget.themeColor,
                ),
                const Text(
                  'No',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Are you a smoker?',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Radio<String>(
                  value: 'Yes',
                  groupValue: _currentSmoker == true ? 'Yes' : 'No',
                  onChanged: (value) {
                    if (_isMounted) {
                      setState(() {
                        _currentSmoker = value == 'Yes';
                      });
                    }
                  },
                  activeColor: widget.themeColor,
                ),
                const Text(
                  'Yes',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Radio<String>(
                  value: 'No',
                  groupValue: _currentSmoker == false ? 'No' : 'Yes',
                  onChanged: (value) {
                    if (_isMounted) {
                      setState(() {
                        _currentSmoker = value == 'Yes';
                      });
                    }
                  },
                  activeColor: widget.themeColor,
                ),
                const Text(
                  'No',
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (Cm)',
                labelStyle: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.white,
                ),
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
              style: const TextStyle(
                fontFamily: 'RobotoSlab',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (Kg)',
                labelStyle: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.white,
                ),
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
              style: const TextStyle(
                fontFamily: 'RobotoSlab',
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 60),
            Center(
              child: ElevatedButton(
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
                    : const Text(
                        'Submit',
                        style: TextStyle(
                          fontFamily: 'RobotoSlab',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
