// main.dart: Entry point of the Flutter app, setting up the MaterialApp and theme
import 'package:flutter/material.dart';
import 'package:dart_task/screens/home_screen.dart';

// Main function to launch the app
void main() {
  runApp(const NewsApp());
}

// NewsApp: Root widget of the application, defining the app's theme and home screen
class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App', // App title displayed in the OS
      theme: ThemeData(
        primarySwatch: Colors.blue, // Primary color theme
        visualDensity: VisualDensity.adaptivePlatformDensity, // Adapts UI density for platform
        scaffoldBackgroundColor: Colors.grey[100], // Light grey background for screens
        appBarTheme: const AppBarTheme(
          elevation: 0, // Flat app bar
          backgroundColor: Colors.blue, // Blue app bar color
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ), // White, bold title text
        ),
      ),
      home: const HomeScreen(), // Set HomeScreen as the initial screen
    );
  }
}