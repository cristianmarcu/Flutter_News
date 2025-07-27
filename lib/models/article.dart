// article.dart: Defines the Article model for storing news article data
class Article {
  final String title; // Required article title
  final String? description; // Optional description
  final String? url; // Optional article URL
  final String? urlToImage; // Optional image URL

  // Constructor with required title and optional fields
  Article({
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
  });

  // Factory method to create an Article from JSON (from NewsAPI)
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No Title', // Fallback if title is null
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
    );
  }

  // Convert Article to JSON for storage in SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
    };
  }
}