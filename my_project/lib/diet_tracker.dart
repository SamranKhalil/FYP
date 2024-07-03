import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_project/home_screen.dart';
import 'package:pie_chart/pie_chart.dart';
import 'add_meal_form.dart';

class DietTracker extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;

  const DietTracker({
    super.key,
    required this.themeColor,
    required this.backgroundColor,
  });

  @override
  _DietTrackerState createState() => _DietTrackerState();
}

class _DietTrackerState extends State<DietTracker> {
  final List<String> _meals = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
  final List<String> addedMeals = [];
  final Map<String, double> dataMap = {
    'Calories': 500,
    'Fats': 180,
    'Carbs': 120,
    'Protein': 80,
  };

  DateTime? _startDate;
  DateTime? _endDate;

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
        return AddMealForm(
          themeColor: widget.themeColor,
          backgroundColor: widget.backgroundColor,
          meals: _meals,
          onMealAdded: (mealType, meal, quantity) {
            setState(() {
              addedMeals.add('$mealType - $meal - $quantity g');
            });
          },
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Add Meal',
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
        backgroundColor: widget.backgroundColor,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: widget.themeColor,
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  fontFamily: 'RobotoSlab',
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _navigateToScreen(
                  context,
                  HomeScreen(
                    themeColor: widget.themeColor,
                    backgroundColor: widget.backgroundColor,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.food_bank_outlined),
              title: const Text('Diet Tracker'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Dashboard if needed
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Profile if needed
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Settings if needed
              },
            ),
          ],
        ),
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Meals',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1),
            ...addedMeals.map((meal) {
              return Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: widget.themeColor,
                ),
                child: Text(
                  meal,
                  style: const TextStyle(
                    fontFamily: 'RobotoSlab',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
