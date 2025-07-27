// favorites_screen.dart: Displays a list of favorited articles
import 'package:flutter/material.dart';
import 'package:dart_task/services/favorites_service.dart';
import 'package:dart_task/models/article.dart';
import 'package:dart_task/widgets/article_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // Service for managing favorites
  final FavoritesService _favoritesService = FavoritesService();
  List<Article> _favorites = []; // List of favorited articles

  @override
  void initState() {
    super.initState();
    _loadFavorites(); // Load favorites on screen initialization
  }

  // Loads favorited articles from SharedPreferences
  Future<void> _loadFavorites() async {
    final favorites = await _favoritesService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _favorites.isEmpty
        ? const Center(child: Text('No favorites yet', style: TextStyle(fontSize: 18)))
        : ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _favorites.length,
      itemBuilder: (context, index) {
        final article = _favorites[index];
        return ArticleTile(
          article: article,
          onFavoriteToggled: (Article article) async {
            await _favoritesService.toggleFavorite(article);
            _loadFavorites(); // Refresh favorites list
          },
          favoritesService: _favoritesService,
        );
      },
    );
  }
}