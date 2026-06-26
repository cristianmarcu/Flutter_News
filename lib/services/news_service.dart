// news_service.dart: Handles fetching news articles from NewsAPI
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_news/models/article.dart';
import 'package:http/http.dart' as http;

const String newsApiKey = String.fromEnvironment('NEWS_API_KEY');

class NewsServiceException implements Exception {
  final String message;
  final bool canRetry;

  const NewsServiceException(this.message, {this.canRetry = true});

  @override
  String toString() => message;
}

class NewsService {
  static const String _baseUrl = 'https://newsapi.org/v2/top-headlines';
  static const Duration _requestTimeout = Duration(seconds: 12);

  Future<List<Article>> fetchArticles() async {
    if (newsApiKey.isEmpty) {
      throw const NewsServiceException(
        'Missing NewsAPI key. Run the app with --dart-define=NEWS_API_KEY=YOUR_NEWS_API_KEY.',
        canRetry: false,
      );
    }

    try {
      final uri = Uri.parse(
        _baseUrl,
      ).replace(queryParameters: const {'country': 'us'});
      final response = await http.get(
        uri,
        headers: const {'X-Api-Key': newsApiKey},
      ).timeout(_requestTimeout);

      if (response.statusCode == 200) {
        return _parseArticles(response.body);
      }

      throw _exceptionForStatusCode(response.statusCode);
    } on TimeoutException {
      throw const NewsServiceException(
        'The request timed out. Check your connection and try again.',
      );
    } on SocketException {
      throw const NewsServiceException(
        'No internet connection. Check your network and try again.',
      );
    } on FormatException {
      throw const NewsServiceException(
        'NewsAPI returned an unreadable response. Please try again later.',
      );
    } on http.ClientException {
      throw const NewsServiceException(
        'Could not reach NewsAPI. Check your connection and try again.',
      );
    }
  }

  List<Article> _parseArticles(String responseBody) {
    final jsonData = jsonDecode(responseBody);
    if (jsonData is! Map<String, dynamic>) {
      throw const FormatException('Expected a JSON object.');
    }

    final articlesJson = jsonData['articles'];
    if (articlesJson is! List) {
      throw const FormatException('Expected an articles list.');
    }

    return articlesJson
        .whereType<Map<String, dynamic>>()
        .map(Article.fromJson)
        .toList();
  }

  NewsServiceException _exceptionForStatusCode(int statusCode) {
    if (statusCode == 401) {
      return const NewsServiceException(
        'NewsAPI rejected the API key. Check NEWS_API_KEY and try again.',
        canRetry: false,
      );
    }

    if (statusCode == 429) {
      return const NewsServiceException(
        'NewsAPI rate limit reached. Please try again later.',
      );
    }

    if (statusCode >= 500) {
      return const NewsServiceException(
        'NewsAPI is temporarily unavailable. Please try again later.',
      );
    }

    return NewsServiceException(
      'Could not load articles. NewsAPI returned HTTP $statusCode.',
    );
  }
}
