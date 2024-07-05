import 'package:flutter/material.dart';

class SubmitHealthForm extends StatefulWidget {
  @override
  _SubmitHealthFormState createState() => _SubmitHealthFormState();
}

class _SubmitHealthFormState extends State<SubmitHealthForm> {
  bool _hasTakenMedicine = false;
  int? _cigarettesPerDay;
  int? _glucoseLevel;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Health Form'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Have you taken your BP medicine today?',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              Row(
                children: [
                  Radio(
                    value: true,
                    groupValue: _hasTakenMedicine,
                    onChanged: (value) {
                      setState(() {
                        _hasTakenMedicine = value as bool;
                      });
                    },
                  ),
                  Text('Yes'),
                  SizedBox(width: 20.0),
                  Radio(
                    value: false,
                    groupValue: _hasTakenMedicine,
                    onChanged: (value) {
                      setState(() {
                        _hasTakenMedicine = value as bool;
                      });
                    },
                  ),
                  Text('No'),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'How many cigarettes per day?',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter number of cigarettes',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of cigarettes per day';
                  }
                  return null;
                },
                onSaved: (value) {
                  _cigarettesPerDay = int.tryParse(value!);
                },
              ),
              SizedBox(height: 20.0),
              Text(
                'Glucose level:',
                style: TextStyle(fontSize: 18.0),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Enter glucose level',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the glucose level';
                  }
                  return null;
                },
                onSaved: (value) {
                  _glucoseLevel = int.tryParse(value!);
                },
              ),
              SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue[100],
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    textStyle: TextStyle(fontSize: 18.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Now you can submit the form data to your backend or perform other actions
      print('Form submitted:');
      print('Has taken medicine: $_hasTakenMedicine');
      print('Cigarettes per day: $_cigarettesPerDay');
      print('Glucose level: $_glucoseLevel');

      // Reset the form after submission
      _formKey.currentState!.reset();
      setState(() {
        _hasTakenMedicine = false;
        _cigarettesPerDay = null;
        _glucoseLevel = null;
      });
    }
  }
}
