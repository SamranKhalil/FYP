import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/diet_tracker.dart';
import 'package:my_project/health_form.dart';
import 'package:my_project/start_screen.dart'; // Assuming StartScreen is imported from this file

class HomeScreen extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;

  const HomeScreen({
    Key? key,
    required this.themeColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int sleepCompleted = 0;
  int walkTimeCompleted = 0;
  int eatFruitsCompleted = 0;
  int walkStepsCompleted = 0;

  Artboard? _artboard;
  late RiveAnimationController _controller;
  String selectedGender = 'male';
  bool isHealthy = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _initializeRive();
  }

  void _loadGoalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      sleepCompleted = prefs.getInt('sleepCompleted') ?? 0;
      walkTimeCompleted = prefs.getInt('walkTimeCompleted') ?? 0;
      eatFruitsCompleted = prefs.getInt('eatFruitsCompleted') ?? 0;
      walkStepsCompleted = prefs.getInt('walkStepsCompleted') ?? 0;
    });
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedGender = prefs.getString('gender') ?? 'male';
      isHealthy = prefs.getBool('isHealthy') ?? true;
    });
  }

  Future<void> _initializeRive() async {
    await RiveFile.initialize();
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    final data = await rootBundle.load('assets/animations.riv');
    final file = RiveFile.import(data);

    setState(() {
      _artboard = file.mainArtboard;
      _controller = SimpleAnimation(isHealthy
          ? '${selectedGender}_idle_happy'
          : '${selectedGender}_critical');
      _artboard!.addController(_controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.themeColor,
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: widget.themeColor,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadGoalData,
          ),
        ],
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
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.food_bank_outlined),
              title: const Text('Diet Tracker'),
              onTap: () {
                Navigator.pop(context);
                _navigateToScreen(
                  context,
                  DietTracker(
                    themeColor: widget.themeColor,
                    backgroundColor: widget.backgroundColor,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_turned_in),
              title: const Text('Submit Health Form'),
              onTap: () {
                Navigator.pop(context);
                _navigateToScreen(
                  context,
                  SubmitHealthForm(),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout), // Changed icon to logout
              title: const Text('Logout'), // Changed title to Logout
              onTap: _logoutAndNavigateToStartScreen, // Call logout method
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              width: 300,
              child: _artboard != null
                  ? Transform.translate(
                      offset: const Offset(0, -50),
                      child: Rive(
                        artboard: _artboard!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const CircularProgressIndicator(),
            ),
            const Text(
              "Daily Target",
              style: TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGoalCard('Sleep', '$sleepCompleted / 7 hours'),
                  _buildGoalCard('Walk Time', '$walkTimeCompleted / 25 mins'),
                  _buildGoalCard(
                      'Eat Fruits', '$eatFruitsCompleted / 500 grams'),
                  _buildGoalCard(
                      'Walk Steps', '$walkStepsCompleted / 10000 steps'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(String title, String progress) {
    return Container(
      width: 135,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            progress,
            style: const TextStyle(
              fontFamily: 'RobotoSlab',
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _logoutAndNavigateToStartScreen() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored preferences
    Navigator.pushReplacement(
      // Navigate to StartScreen and remove this page from stack
      context,
      MaterialPageRoute(builder: (context) => const StartScreen()),
    );
  }
}
