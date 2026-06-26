import 'package:flutter/material.dart';
import 'package:flutter_news/models/article.dart';
import 'package:flutter_news/services/favorites_service.dart';
import 'package:flutter_news/services/news_service.dart';
import 'package:flutter_news/widgets/article_tile.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  final FavoritesService _favoritesService = FavoritesService();
  List<Article> _articles = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _canRetry = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
  }

  Future<void> _fetchArticles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final articles = await _newsService.fetchArticles();
      if (!mounted) return;
      setState(() {
        _articles = articles;
        _isLoading = false;
        _errorMessage = null;
        _canRetry = true;
      });
    } on NewsServiceException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
        _canRetry = e.canRetry;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong while loading articles.';
        _canRetry = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          const _NewsHeader(),
          Expanded(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return const _MessageState(
        icon: Icons.sync_rounded,
        message: 'Loading top headlines...',
        showProgress: true,
      );
    }

    if (_errorMessage != null) {
      return _MessageState(
        icon: Icons.error_outline,
        message: _errorMessage!,
        actionLabel: _canRetry ? 'Retry' : null,
        onActionPressed: _canRetry ? _fetchArticles : null,
      );
    }

    if (_articles.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchArticles,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const _MessageState(
                icon: Icons.article_outlined,
                message: 'No headlines found. Pull down to refresh.',
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchArticles,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
        itemCount: _articles.length,
        itemBuilder: (context, index) {
          final article = _articles[index];
          return ArticleTile(
            article: article,
            onFavoriteToggled: (Article article) async {
              await _favoritesService.toggleFavorite(article);
            },
            favoritesService: _favoritesService,
          );
        },
      ),
    );
  }
}

class _NewsHeader extends StatelessWidget {
  const _NewsHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFEFF4FA)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'News Flow',
            style: textTheme.headlineMedium?.copyWith(
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Top headlines',
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

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool showProgress;

  const _MessageState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFE8EEF6),
                shape: BoxShape.circle,
              ),
              child: showProgress
                  ? const Padding(
                      padding: EdgeInsets.all(18),
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Icon(icon, size: 32, color: const Color(0xFF1E3A5F)),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF374151),
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
