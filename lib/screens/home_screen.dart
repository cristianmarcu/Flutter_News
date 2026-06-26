import 'package:flutter/material.dart';
import 'package:flutter_news/screens/favorites_screen.dart';
import 'package:flutter_news/screens/news_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const NewsScreen(),
    const FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        height: 72,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE8EEF6),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.newspaper_outlined),
            selectedIcon: Icon(Icons.newspaper),
            label: 'Headlines',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_border_rounded),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
        ],
      ),
    );
  }
}
