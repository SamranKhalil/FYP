// diet_tracker.dart
import 'package:flutter/material.dart';
import 'package:my_project/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pie_chart/pie_chart.dart';
import 'add_meal_form.dart'; // Import the new file

class DietTracker extends StatefulWidget {
  final Color themeColor;
  final String token;
  const DietTracker({super.key, required this.themeColor, required this.token});

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

  String _selectedPeriod = 'Day';

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
          meals: _meals,
          onMealAdded: (meal, quantity) {
            setState(() {
              addedMeals.add('$meal - $quantity g');
            });
          },
        );
      },
    );
  }

  void _onPeriodSelected(String period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  Widget _buildPeriodText(String period) {
    return GestureDetector(
      onTap: () => _onPeriodSelected(period),
      child: Text(
        period,
        style: GoogleFonts.robotoSlab(
          color: Colors.black,
          fontSize: 16,
          fontWeight:
              _selectedPeriod == period ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Add Meal',
              style: GoogleFonts.robotoSlab(
                color: Colors.black,
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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: widget.themeColor,
              ),
              child: Text(
                'Menu',
                style: GoogleFonts.robotoSlab(
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
                        themeColor: widget.themeColor, token: widget.token));
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPeriodText('Day'),
                _buildPeriodText('Week'),
                _buildPeriodText('Month'),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(30.0),
              margin: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.green[900],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Your Daily Nutrition',
                    style: GoogleFonts.robotoSlab(
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
                          color: Colors.white),
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
                color: Colors.green[900],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Meals',
                    style: GoogleFonts.robotoSlab(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1),
            // Display each added meal in a new rectangle
            ...addedMeals.map((meal) {
              return Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.green[900],
                ),
                child: Text(
                  meal,
                  style: GoogleFonts.robotoSlab(
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
