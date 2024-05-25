import 'package:flutter/material.dart';

class SignupPageGender extends StatefulWidget {
  final Color themeColor;

  const SignupPageGender({Key? key, required this.themeColor})
      : super(key: key);

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
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Gender',
              style: TextStyle(fontSize: 20),
            ),
            RadioListTile<String>(
              title: const Text(
                'Male',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              value: 'Male',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              activeColor: widget.themeColor, // Set the color when selected
              dense: true, // Reduce the size of the tile
            ),
            RadioListTile<String>(
              title: const Text(
                'Female',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              value: 'Female',
              groupValue: _selectedGender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
              activeColor: widget.themeColor, // Set the color when selected
              dense: true, // Reduce the size of the tile
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Height(Cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight(Kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(
                  const EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  widget.themeColor,
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
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
