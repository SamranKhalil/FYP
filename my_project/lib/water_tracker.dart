import 'package:flutter/material.dart';

class WaterTracker extends StatelessWidget {
  final Color themeColor;
  final Color backgroundColor;

  const WaterTracker({
    super.key,
    required this.themeColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Water Tracker',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
