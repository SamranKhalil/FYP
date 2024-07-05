import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WaterTracker extends StatefulWidget {
  final Color themeColor;
  final Color backgroundColor;

  const WaterTracker({
    Key? key,
    required this.themeColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _WaterTrackerState createState() => _WaterTrackerState();
}

class _WaterTrackerState extends State<WaterTracker> {
  int _goal = 1200; // Default goal
  int _currentWater = 0; // Amount of water consumed
  int _glassSize = 200; // Default glass size

  void _incrementWater() {
    setState(() {
      _currentWater += _glassSize;
      if (_currentWater > _goal) {
        _currentWater = _goal;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Water Tracker',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/water_image.jpeg',
              height: 100,
              width: 500,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 80),
            Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white, // Set circle background to white
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_currentWater/$_goal ml',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.blue[200],
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Daily Drink Target',
                    style: TextStyle(
                      fontFamily: 'RobotoSlab',
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.local_drink,
                            size: 60, color: Colors.blue[300]),
                        onPressed: _incrementWater,
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh,
                            size: 30, color: Colors.black),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButton<int>(
                                      value: _glassSize, // Set initial value
                                      icon: const Icon(Icons.refresh),
                                      onChanged: (int? newValue) {
                                        if (newValue != null) {
                                          setState(() {
                                            _glassSize = newValue;
                                          });
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      items: <int>[
                                        100,
                                        150,
                                        200,
                                        300
                                      ].map<DropdownMenuItem<int>>((int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text('$value ml'),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
