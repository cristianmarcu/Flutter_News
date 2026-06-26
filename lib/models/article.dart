class Article {
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? sourceName;
  final DateTime? publishedAt;

  Article({
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.sourceName,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: _stringValue(json['title']) ?? 'Untitled article',
      description: _stringValue(json['description']),
      url: _stringValue(json['url']),
      urlToImage: _stringValue(json['urlToImage']),
      sourceName:
          _sourceName(json['source']) ?? _stringValue(json['sourceName']),
      publishedAt: _dateTimeValue(json['publishedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'source': sourceName == null ? null : {'name': sourceName},
      'sourceName': sourceName,
      'publishedAt': publishedAt?.toIso8601String(),
    };
  }

  static String? _stringValue(dynamic value) {
    if (value is! String) return null;

    final trimmedValue = value.trim();
    return trimmedValue.isEmpty ? null : trimmedValue;
  }

  static String? _sourceName(dynamic source) {
    if (source is Map<String, dynamic>) {
      return _stringValue(source['name']);
    }

    return null;
  }

  static DateTime? _dateTimeValue(dynamic value) {
    final dateString = _stringValue(value);
    if (dateString == null) return null;

    return DateTime.tryParse(dateString);
  }
}
