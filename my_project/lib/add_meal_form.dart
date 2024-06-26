// add_meal_form.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddMealForm extends StatefulWidget {
  final List<String> meals;
  final Function(String, String) onMealAdded;

  const AddMealForm(
      {super.key, required this.meals, required this.onMealAdded});

  @override
  _AddMealFormState createState() => _AddMealFormState();
}

class _AddMealFormState extends State<AddMealForm> {
  String? _selectedMeal;
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Add Meal Form',
            style: TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Meal',
            ),
            value: _selectedMeal,
            items: widget.meals.map((meal) {
              return DropdownMenuItem(
                value: meal,
                child: Text(meal),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedMeal = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(
              labelText: 'Quantity (Grams)',
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_selectedMeal != null &&
                  _quantityController.text.isNotEmpty) {
                String meal = _selectedMeal!;
                String quantity = _quantityController.text;

                widget.onMealAdded(meal, quantity);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Meal added: $meal, Quantity: $quantity')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text('Add Meal'),
          ),
        ],
      ),
    );
  }
}
