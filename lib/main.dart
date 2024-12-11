//IM-2021-022
//purpose of the code - entry point of the Flutter application and manage the app's theme


// Importing necessary packages
import 'package:flutter/material.dart'; // Core Flutter framework
import 'calcualtor_screen.dart'; // Importing the CalculatorScreen widget

// Main function: Entry point of the application
void main() {
  runApp(const MyApp()); // Runs the root widget of the app
}

// Root widget of the application, which manages the app state
class MyApp extends StatefulWidget {
  const MyApp({super.key}); // Constructor for MyApp

  @override
  State<MyApp> createState() => _MyAppState(); // Creates the mutable state for the widget
}

// State class for MyApp, which handles the app's theme switching logic
class _MyAppState extends State<MyApp> {
  // Variable to hold the current theme mode (light or dark)

  ThemeMode _themeMode = ThemeMode.light; // Default theme is light mode

  // Method to toggle between light and dark themes
  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
      // If the current theme is light, switch to dark. Otherwise, switch to light.
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator', // Title of the application
      debugShowCheckedModeBanner: false, // Disables the debug banner in the app
      themeMode: _themeMode, // Dynamically applies the current theme (light or dark)
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color for light mode
        brightness: Brightness.light, // Brightness setting for light mode
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue, // Primary color for dark mode
        brightness: Brightness.dark, // Brightness setting for dark mode
      ),
      home: CalculatorScreen(
        onToggleTheme: _toggleTheme, // Passes the toggle function to the CalculatorScreen widget
      ),
    );
  }
}
