// home_screen.dart: Main screen with bottom navigation for News and Favorites tabs
import 'package:flutter/material.dart';
import 'package:dart_task/screens/news_screen.dart';
import 'package:dart_task/screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Tracks the currently selected tab (0 = News, 1 = Favorites)
  int _selectedIndex = 0;

  // List of screens for navigation
  static final List<Widget> _screens = <Widget>[
    const NewsScreen(),
    const FavoritesScreen(),
  ];

  // Handles tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'), // App bar title
      ),
      body: _screens.elementAt(_selectedIndex), // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // Blue for selected tab
        unselectedItemColor: Colors.grey, // Grey for unselected tab
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: _onItemTapped, // Update selected tab
      ),
    );
  }
}