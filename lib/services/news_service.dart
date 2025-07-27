// news_service.dart: Handles fetching news articles from NewsAPI
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dart_task/models/article.dart';

class NewsService {
  // API key for NewsAPI (provided by https://newsapi.org/)
  static const String _apiKey = 'cd2e5aa04cfe4efd9a1eb1d16e54f53b';
  // Base URL for NewsAPI top headlines endpoint
  static const String _baseUrl = 'https://newsapi.org/v2/top-headlines';

  // Fetches top headlines from NewsAPI for the US
  Future<List<Article>> fetchArticles() async {
    try {
      // Make HTTP GET request with API key and country parameter
      final response = await http.get(Uri.parse('$_baseUrl?country=us&apiKey=$_apiKey'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['articles'] != null) {
          // Map JSON articles to List<Article>
          return (jsonData['articles'] as List)
              .map((article) => Article.fromJson(article))
              .toList();
        } else {
          throw Exception('No articles found in response');
        }
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching articles: $e');
    }
  }
}