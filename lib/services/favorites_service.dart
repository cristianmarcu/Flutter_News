import 'dart:convert';

import 'package:flutter_news/models/article.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const String _favoritesKey = 'favorites';

  Future<void> toggleFavorite(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();

    if (favorites.any((fav) => fav.title == article.title)) {
      favorites.removeWhere((fav) => fav.title == article.title);
    } else {
      favorites.add(article);
    }

    final favoritesJson =
        favorites.map((fav) => json.encode(fav.toJson())).toList();
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  Future<List<Article>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
      return favoritesJson
          .map(_articleFromStoredJson)
          .whereType<Article>()
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> isFavorite(String title) async {
    final favorites = await getFavorites();
    return favorites.any((article) => article.title == title);
  }

  Article? _articleFromStoredJson(String jsonString) {
    final decodedJson = json.decode(jsonString);
    if (decodedJson is! Map<String, dynamic>) return null;

    return Article.fromJson(decodedJson);
  }
}
