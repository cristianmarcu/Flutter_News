// favorites_service.dart: Manages favorite articles using SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_task/models/article.dart';
import 'dart:convert';

class FavoritesService {
  // Key for storing favorites in SharedPreferences
  static const String _favoritesKey = 'favorites';

  // Toggles an article's favorite status (add/remove)
  Future<void> toggleFavorite(Article article) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();

      if (favorites.any((fav) => fav.title == article.title)) {
        // Remove article if already favorited
        favorites.removeWhere((fav) => fav.title == article.title);
      } else {
        // Add article to favorites
        favorites.add(article);
      }

      // Convert favorites to JSON and save to SharedPreferences
      final favoritesJson = favorites.map((fav) => json.encode(fav.toJson())).toList();
      await prefs.setStringList(_favoritesKey, favoritesJson);
    } catch (e) {
      print('Error in toggleFavorite: $e'); // Debug: Log errors
      rethrow;
    }
  }

  // Retrieves all favorited articles
  Future<List<Article>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      final favorites = favoritesJson
          .map((jsonString) => Article.fromJson(json.decode(jsonString)))
          .toList();
      return favorites;
    } catch (e) {
      return [];
    }
  }

  // Checks if an article is favorited
  Future<bool> isFavorite(String title) async {
    final favorites = await getFavorites();
    return favorites.any((article) => article.title == title);
  }
}