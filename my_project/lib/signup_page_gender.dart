import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPageGender extends StatefulWidget {
  final Color themeColor;

  const SignupPageGender({super.key, required this.themeColor});

  @override
  _SignupPageGenderState createState() => _SignupPageGenderState();
}

class _SignupPageGenderState extends State<SignupPageGender> {
  String? _selectedGender;
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
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
                setState(() {
                  _selectedGender = value;
                });
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
                setState(() {
                  _selectedGender = value;
                });
              },
              activeColor: widget.themeColor,
              dense: true,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
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
              onPressed: () {},
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
