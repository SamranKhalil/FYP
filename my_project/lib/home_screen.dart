import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:my_project/diet_tracker.dart';
import 'package:my_project/water_tracker.dart';
import 'package:my_project/weight_tracker.dart';
import 'package:my_project/steps_tracker.dart';

class HomeScreen extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;

  const HomeScreen({
    super.key,
    required this.themeColor,
    required this.backgroundColor,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Artboard? _artboard;
  late RiveAnimationController _controller;
  bool isWalking = false;

  @override
  void initState() {
    super.initState();
    _initializeRive();
    _initializeAccelerometer();
  }

  Future<void> _initializeRive() async {
    await RiveFile.initialize();
    _loadRiveFile();
  }

  void _loadRiveFile() async {
    final data = await rootBundle.load('assets/untitled.riv');
    final file = RiveFile.import(data);

    setState(() {
      _artboard = file.mainArtboard;
      _controller = SimpleAnimation('idle happy 2');
      _artboard!.addController(_controller);
    });
  }

  void _initializeAccelerometer() {
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        if (event.x.abs() > 1.0 || event.y.abs() > 1.0) {
          if (!isWalking) {
            _controller = SimpleAnimation('walking 2');
            _artboard?.addController(_controller);
            isWalking = true;
          }
        } else {
          if (isWalking) {
            _controller = SimpleAnimation('idle happy 2');
            _artboard?.addController(_controller);
            isWalking = false;
          }
        }
      });
    });
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
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
                // No need to navigate since we're already on Home
              },
            ),
            ListTile(
              leading: const Icon(Icons.food_bank_outlined),
              title: const Text('Diet Tracker'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
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
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Profile screen
                // _navigateToScreen(context, ProfileScreen(themeColor: widget.themeColor));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Navigate to Settings screen
                // _navigateToScreen(context, SettingsScreen(themeColor: widget.themeColor));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 500, // Adjusted height for the animation
              width: 300, // Adjusted width for the animation
              child: _artboard != null
                  ? Transform.translate(
                      offset: const Offset(0, -50), // Move the animation up
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
              height: 10, // Add some spacing between the avatar and the metrics
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildGoalButton('Water', '52%'),
                  _buildGoalButton('Calories', '60%'),
                  _buildGoalButton('Steps', '80%'),
                  _buildGoalButton('Weight', '80%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalButton(String label, String percentage) {
    return InkWell(
      onTap: () {
        if (label == 'Calories') {
          _navigateToScreen(
            context,
            DietTracker(
              themeColor: widget.themeColor,
              backgroundColor: widget.backgroundColor,
            ),
          );
        } else if (label == 'Water') {
          _navigateToScreen(
            context,
            WaterTracker(
              themeColor: widget.themeColor,
              backgroundColor: widget.backgroundColor,
            ),
          );
        } else if (label == 'Steps') {
          _navigateToScreen(
            context,
            StepsTracker(
              themeColor: widget.themeColor,
              backgroundColor: widget.backgroundColor,
            ),
          );
        } else if (label == 'Weight') {
          _navigateToScreen(
            context,
            WeightTracker(
              themeColor: widget.themeColor,
              backgroundColor: widget.backgroundColor,
            ),
          );
        }
      },
      child: Container(
        width: 100, // Fixed width for all cards
        margin: const EdgeInsets.symmetric(horizontal: 5),
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
          children: [
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                value: double.parse(percentage.replaceAll('%', '')) / 100,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation(widget.themeColor),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              percentage,
              style: const TextStyle(
                fontFamily: 'RobotoSlab',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
