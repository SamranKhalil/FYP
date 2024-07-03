import 'package:flutter/material.dart';

class AddMealForm extends StatefulWidget {
  final List<String> meals;
  final Color themeColor;
  final Color backgroundColor;
  final Function(String, String, String) onMealAdded;

  const AddMealForm({
    super.key,
    required this.themeColor,
    required this.backgroundColor,
    required this.meals,
    required this.onMealAdded,
  });

  @override
  _AddMealFormState createState() => _AddMealFormState();
}

class _AddMealFormState extends State<AddMealForm> {
  String? _selectedMeal;
  String? _selectedMealType;
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Add Meal Form',
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'RobotoSlab',
              fontWeight: FontWeight.bold,
              color: widget.themeColor,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Meal Type',
              labelStyle: TextStyle(
                fontFamily: 'RobotoSlab',
                color: widget.themeColor,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.themeColor,
                ),
              ),
            ),
            value: _selectedMealType,
            items: ['Beverage', 'Hard Food'].map((mealType) {
              return DropdownMenuItem(
                value: mealType,
                child: Text(
                  mealType,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: widget.themeColor,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedMealType = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Meal',
              labelStyle: TextStyle(
                fontFamily: 'RobotoSlab',
                color: widget.themeColor,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.themeColor,
                ),
              ),
            ),
            value: _selectedMeal,
            items: widget.meals.map((meal) {
              return DropdownMenuItem(
                value: meal,
                child: Text(
                  meal,
                  style: TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: widget.themeColor,
                  ),
                ),
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
            decoration: InputDecoration(
              labelText: 'Quantity (Grams)',
              labelStyle: TextStyle(
                fontFamily: 'RobotoSlab',
                color: widget.themeColor,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: widget.themeColor,
                ),
              ),
            ),
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontFamily: 'RobotoSlab',
              color: widget.themeColor,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_selectedMealType != null &&
                  _selectedMeal != null &&
                  _quantityController.text.isNotEmpty) {
                String mealType = _selectedMealType!;
                String meal = _selectedMeal!;
                String quantity = _quantityController.text;

                widget.onMealAdded(mealType, meal, quantity);

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Meal added: $mealType, $meal, Quantity: $quantity',
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please fill all fields',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                      ),
                    ),
                  ),
                );
              }
            },
            child: Text(
              'Add Meal',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 16,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.themeColor,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(
                fontFamily: 'RobotoSlab',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
