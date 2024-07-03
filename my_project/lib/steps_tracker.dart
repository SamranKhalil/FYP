import 'package:flutter/material.dart';

class StepsTracker extends StatelessWidget {
  final Color themeColor;
  final Color backgroundColor;

  const StepsTracker({
    super.key,
    required this.themeColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Steps Tracker',
          style: TextStyle(
            fontFamily: 'RobotoSlab',
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: themeColor,
      ),
      body: const Center(
        child: Text(
          'Empty Page',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
