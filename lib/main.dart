import 'package:flutter/material.dart';
import 'package:notes/home.dart';
import 'package:notes/splash_screen.dart';

void main() => runApp(MainApp());

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Simulate a delay for the splash screen
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _showSplash ? SplashScreen() : HomeScreen(),
    );
  }
}

