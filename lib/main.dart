import 'package:flutter/material.dart';
import 'home_screen.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Calculator',
      theme: ThemeData.dark( ),
      home: const CalculatorApp(),
       
    );
  }
}
