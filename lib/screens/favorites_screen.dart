import 'package:flutter/material.dart';
import 'package:flutter_news/models/article.dart';
import 'package:flutter_news/services/favorites_service.dart';
import 'package:flutter_news/widgets/article_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  List<Article> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoritesService.getFavorites();
    if (!mounted) return;
    setState(() {
      _favorites = favorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _FavoritesHeader(savedCount: _favorites.length),
          Expanded(
            child: _favorites.isEmpty
                ? const _FavoritesEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final article = _favorites[index];
                      return ArticleTile(
                        article: article,
                        onFavoriteToggled: (Article article) async {
                          await _favoritesService.toggleFavorite(article);
                          await _loadFavorites();
                        },
                        favoritesService: _favoritesService,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesHeader extends StatelessWidget {
  final int savedCount;

  const _FavoritesHeader({required this.savedCount});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved articles',
            style: textTheme.headlineSmall?.copyWith(
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            savedCount == 1 ? '1 article saved' : '$savedCount articles saved',
            style: textTheme.titleMedium?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Color(0xFFE8EEF6),
                shape: BoxShape.circle,
              ),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Icon(
                  Icons.bookmark_border_rounded,
                  color: Color(0xFF1E3A5F),
                  size: 34,
                ),
              ),
            ),
            SizedBox(height: 18),
            Text(
              'No saved articles yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF111827),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Bookmark a headline to keep it here for later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF64748B), fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
