import 'package:flutter/material.dart';
import 'package:flutter_news/models/article.dart';
import 'package:flutter_news/services/favorites_service.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> _launchUrl(String? url) async {
  final trimmedUrl = url?.trim();
  if (trimmedUrl == null || trimmedUrl.isEmpty) return false;

  final uri = Uri.tryParse(trimmedUrl);
  if (uri == null || !uri.hasScheme) return false;

  return launchUrl(uri, mode: LaunchMode.externalApplication);
}

class ArticleTile extends StatefulWidget {
  final Article article;
  final Function(Article) onFavoriteToggled;
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
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await widget.favoritesService.isFavorite(
      widget.article.title,
    );
    if (!mounted) return;
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  Future<void> _handleArticleTap() async {
    try {
      final launched = await _launchUrl(widget.article.url);
      if (launched) return;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this article.')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open this article.')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    final previousValue = _isFavorite;
    setState(() {
      _isFavorite = !_isFavorite;
    });

    try {
      await widget.onFavoriteToggled(widget.article);
      await _checkFavoriteStatus();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isFavorite = previousValue;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not update favorites.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final metaText = _articleMeta(widget.article);

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: _handleArticleTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ArticleImage(imageUrl: widget.article.urlToImage),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (metaText != null) ...[
                          Text(
                            metaText,
                            style: textTheme.labelMedium?.copyWith(
                              color: const Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          widget.article.title,
                          style: textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF111827),
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    tooltip: _isFavorite ? 'Remove from saved' : 'Save article',
                    style: IconButton.styleFrom(
                      backgroundColor: _isFavorite
                          ? const Color(0xFFFFE8E8)
                          : const Color(0xFFE8EEF6),
                      foregroundColor: _isFavorite
                          ? const Color(0xFFC2410C)
                          : const Color(0xFF1E3A5F),
                    ),
                    icon: Icon(
                      _isFavorite
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
              if (widget.article.description != null) ...[
                const SizedBox(height: 10),
                Text(
                  widget.article.description!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF4B5563),
                    height: 1.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String? _articleMeta(Article article) {
    final parts = <String>[
      if (article.sourceName != null) article.sourceName!,
      if (article.publishedAt != null) _formatDate(article.publishedAt!),
    ];

    return parts.isEmpty ? null : parts.join(' - ');
  }

  String _formatDate(DateTime dateTime) {
    final localDate = dateTime.toLocal();
    final month = _monthNames[localDate.month - 1];
    return '$month ${localDate.day}, ${localDate.year}';
  }
}

const List<String> _monthNames = <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

class _ArticleImage extends StatelessWidget {
  final String? imageUrl;

  const _ArticleImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final imageUrl = this.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: imageUrl == null
            ? const _ImageFallback()
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  return const _ImageFallback(isLoading: true);
                },
                errorBuilder: (context, error, stackTrace) =>
                    const _ImageFallback(),
              ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final bool isLoading;

  const _ImageFallback({this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8EEF6),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(
                Icons.image_not_supported_outlined,
                color: Color(0xFF64748B),
                size: 34,
              ),
      ),
    );
  }
}
