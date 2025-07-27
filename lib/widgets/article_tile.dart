// article_tile.dart: Widget for displaying a single article with a favorite button and tappable content
import 'package:flutter/material.dart';
import 'package:dart_task/models/article.dart';
import 'package:dart_task/services/favorites_service.dart';
import 'package:url_launcher/url_launcher.dart';

// Launches a URL in the default browser with debug logging
Future<void> _launchUrl(String? url) async {
  if (url == null || url.isEmpty) {
    debugPrint('Invalid URL: null or empty');
    return; // Skip if URL is null or empty
  }
  debugPrint('Attempting to launch URL: $url');
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    debugPrint('URL can be launched: $url');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('Failed to launch URL: $url');
    throw 'Could not launch $url';
  }
}

class ArticleTile extends StatefulWidget {
  final Article article;
  final Function(Article) onFavoriteToggled; // Callback for favorite toggle
  final FavoritesService favoritesService;

  const ArticleTile({
    super.key,
    required this.article,
    required this.onFavoriteToggled,
    required this.favoritesService,
  });

  @override
  State<ArticleTile> createState() => _ArticleTileState();
}

class _ArticleTileState extends State<ArticleTile> {
  bool _isFavorite = false; // Local state for favorite status

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus(); // Initialize favorite status
  }

  // Checks if the article is favorited, with mounted check for async safety
  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await widget.favoritesService.isFavorite(widget.article.title);
    if (!mounted) return; // Avoid setState if widget is unmounted
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  // Opens the article URL in the browser, shows an error if it fails
  Future<void> _handleArticleTap() async {
    try {
      await _launchUrl(widget.article.url);
    } catch (e) {
      if (!mounted) return; // Avoid using BuildContext if unmounted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open article: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Builds the UI without side effects
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      child: InkWell(
        // Tappable card to open article URL
        onTap: _handleArticleTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display article image if available
              if (widget.article.urlToImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.article.urlToImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 100),
                  ),
                ),
              const SizedBox(width: 12),
              // Article title and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.article.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (widget.article.description != null)
                      Text(
                        widget.article.description!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              // Favorite button with single-click toggle
              IconButton(
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () async {
                  setState(() {
                    _isFavorite = !_isFavorite; // Update UI immediately
                  });
                  await widget.onFavoriteToggled(widget.article); // Update SharedPreferences
                  await _checkFavoriteStatus(); // Sync with FavoritesService
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}