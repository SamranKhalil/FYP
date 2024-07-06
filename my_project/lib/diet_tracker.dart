import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DietTracker extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;

  const DietTracker({
    Key? key,
    required this.themeColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _DietTrackerState createState() => _DietTrackerState();
}

class _DietTrackerState extends State<DietTracker> {
  final List<String> _meals = ['apple', 'orange', 'mango', 'ginger'];
  final List<String> addedMeals = [];
  final Map<String, double> dataMap = {
    'Calories': 0,
    'Protein': 0,
    'Fats': 0,
    'Carbs': 0,
    'Minerals': 0,
  };

  DateTime? _startDate;
  DateTime? _endDate;

  List<dynamic> foodList = [];

  String? _selectedMeal;
  String? _selectedMealType;
  final TextEditingController _quantityController = TextEditingController();

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _showAddMealForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
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
                items: _meals.map((meal) {
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

                    _addMeal(mealType, meal, quantity);

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Meal added: $mealType, $meal, Quantity: $quantity',
                          style: TextStyle(
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
      },
    );
  }

  void _selectDateRange(BuildContext context) async {
    final DateTime today = DateTime.now().toUtc().add(const Duration(hours: 5));
    final DateTime firstDate = DateTime(today.year - 5);
    final DateTime lastDate = DateTime(today.year + 5);

    final List<DateTime>? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    ).then((range) => range != null ? [range.start, range.end] : null);

    if (picked != null && picked.length == 2) {
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
        _fetchData();
      });
    }
  }

  Future<void> _fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');

    if (token != null && _startDate != null && _endDate != null) {
      final String formattedStartDate =
          DateFormat('yyyy-MM-dd').format(_startDate!);
      final String formattedEndDate =
          DateFormat('yyyy-MM-dd').format(_endDate!);

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/user/intake/summary/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          'start_date': formattedStartDate,
          'end_date': formattedEndDate,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);

        setState(() {
          dataMap['Calories'] = result['nutrients']['total_calories'];
          dataMap['Protein'] = result['nutrients']['protein_percentage'];
          dataMap['Fats'] = result['nutrients']['fat_percentage'];
          dataMap['Carbs'] = result['nutrients']['carbohydrates_percentage'];
          dataMap['Minerals'] = result['nutrients']['minerals_percentage'];

          foodList = result['foodList'];
          addedMeals.clear();
          for (var food in foodList) {
            addedMeals.add(
                '${food['food_name']} - ${food['calories']} - ${food['quantity']} g');
          }
        });
        print("success");
      } else {
        print('Failed to load data');
      }
    }
  }

  Future<void> _addMeal(String mealType, String meal, String quantity) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');
    print(token);

    if (token != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/user/intake/add/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
        body: jsonEncode({
          'food_item': meal,
          'quantity': quantity,
          'is_drink': mealType == 'Beverage',
        }),
      );

      if (response.statusCode == 200) {
        print('Meal added successfully');
        // Refresh data after adding meal
        _fetchData();
      } else {
        print('Failed to add meal');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to add meal. Please try again later.',
              style: TextStyle(
                fontFamily: 'RobotoSlab',
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _sendDataOnBackPressed() async {
    // Send GET request to backend
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('access_token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8000/user/daily-goal-status/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> result = jsonDecode(response.body);
        await prefs.setInt('sleepCompleted', 0);
        await prefs.setInt('walkTimeCompleted', 0);
        await prefs.setInt('eatFruitsCompleted', 0);
        await prefs.setInt('walkStepsCompleted', 0);

        for (var item in result) {
          int goal = item['goal'];
          double amountAchieved = double.parse(item['amount_achieved']);
          int amount = amountAchieved.toInt();
          switch (goal) {
            case 1:
              await prefs.setInt('sleepCompleted', amount);
              break;
            case 2:
              await prefs.setInt('walkTimeCompleted', amount);
              break;
            case 3:
              await prefs.setInt('eatFruitsCompleted', amount);
              break;
            case 4:
              await prefs.setInt('walkStepsCompleted', amount);
              break;
            default:
          }
        }
        print('Data stored successfully');
      } else {
        print('Failed to fetch data on back press');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _sendDataOnBackPressed();
        return true;
      },
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              await _sendDataOnBackPressed();
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                'Diet Tracker',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.themeColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () {
                    _showAddMealForm(context);
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: widget.themeColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => _selectDateRange(context),
                    child: Text(
                      _startDate != null && _endDate != null
                          ? '${DateFormat('d-MMMM-yyyy').format(_startDate!)} to ${DateFormat('d-MMMM-yyyy').format(_endDate!)}'
                          : 'Select Date Range',
                      style: const TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(30.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.themeColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your Daily Nutrition',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    PieChart(
                      dataMap: dataMap,
                      chartType: ChartType.ring,
                      ringStrokeWidth: 32,
                      chartRadius: MediaQuery.of(context).size.width / 3,
                      colorList: [
                        Colors.blue,
                        Colors.green,
                        Colors.orange,
                        Colors.red,
                        Colors.purple,
                      ],
                      legendOptions: const LegendOptions(
                        showLegends: true,
                        legendPosition: LegendPosition.right,
                        showLegendsInRow: false,
                        legendTextStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValuesOutside: true,
                        showChartValues: true,
                        showChartValuesInPercentage: true,
                        showChartValueBackground: true,
                        decimalPlaces: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.themeColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Meals',
                      style: TextStyle(
                        fontFamily: 'RobotoSlab',
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...addedMeals.map((meal) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Text(
                          meal,
                          style: const TextStyle(
                            fontFamily: 'RobotoSlab',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
