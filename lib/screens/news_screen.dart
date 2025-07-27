// news_screen.dart: Displays a list of news articles with pull-to-refresh
import 'package:flutter/material.dart';
import 'package:dart_task/services/news_service.dart';
import 'package:dart_task/services/favorites_service.dart';
import 'package:dart_task/models/article.dart';
import 'package:dart_task/widgets/article_tile.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // Services for fetching articles and managing favorites
  final NewsService _newsService = NewsService();
  final FavoritesService _favoritesService = FavoritesService();
  List<Article> _articles = []; // List of fetched articles
  bool _isLoading = true; // Loading state
  String? _errorMessage; // Error message if fetch fails

  @override
  void initState() {
    super.initState();
    _fetchArticles(); // Fetch articles on screen initialization
  }

  // Fetches articles from NewsAPI
  Future<void> _fetchArticles() async {
    try {
      final articles = await _newsService.fetchArticles();
      setState(() {
        _articles = articles;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator()); // Show loading spinner
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: $_errorMessage',
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchArticles, // Retry fetching articles
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Display articles in a scrollable list with pull-to-refresh
    return RefreshIndicator(
      onRefresh: _fetchArticles,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return ArticleTile(
            article: article,
            onFavoriteToggled: (Article article) async {
              await _favoritesService.toggleFavorite(article); // Toggle favorite status
            },
            favoritesService: _favoritesService,
          );
        },
      ),
    );
  }
}