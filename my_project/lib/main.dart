import 'package:flutter/material.dart';
import 'package:my_project/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: StartScreen(),
  ));
}
