// file: lib/app/core/widgets/music_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/utils/helpers.dart';

/// Music card widget for displaying track information
/// Expected track data format:
/// {
///   "id": "...",
///   "title": "...",
///   "artist": "...",
///   "album": "...",
///   "duration": 180000,
///   "artworkUrl": "...",
///   "isFavorite": false
/// }
class MusicCard extends StatelessWidget {
  final dynamic track;
  final VoidCallback? onTap;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onMorePressed;
  final bool showAlbum;

  const MusicCard({
    super.key,
    required this.track,
    this.onTap,
    this.onFavoritePressed,
    this.onMorePressed,
    this.showAlbum = false,
  });

  @override
  Widget build(BuildContext context) {
    final String title = track['title'] ?? 'Unknown Title';
    final String artist = track['artist'] ?? 'Unknown Artist';
    final String? album = track['album'];
    final int duration = track['duration'] ?? 0;
    final String? artworkUrl = track['artworkUrl'];
    final bool isFavorite = track['isFavorite'] ?? false;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Artwork
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: artworkUrl != null
                  ? CachedNetworkImage(
                      imageUrl: artworkUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 56,
                        height: 56,
                        color: AppTheme.surfaceColor,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 56,
                        height: 56,
                        color: AppTheme.surfaceColor,
                        child: const Icon(
                          Icons.music_note,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                    )
                  : Container(
                      width: 56,
                      height: 56,
                      color: AppTheme.surfaceColor,
                      child: const Icon(
                        Icons.music_note,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            
            // Track info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    showAlbum && album != null ? '$artist • $album' : artist,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Duration
            if (duration > 0) ...[
              Text(
                Helpers.formatDuration(duration),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(width: 12),
            ],
            
            // Favorite button
            if (onFavoritePressed != null)
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
                ),
                onPressed: onFavoritePressed,
              ),
            
            // More button
            if (onMorePressed != null)
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: AppTheme.textSecondaryColor,
                ),
                onPressed: onMorePressed,
              ),
          ],
        ),
      ),
    );
  }
}

/// Compact music card for mini player
class CompactMusicCard extends StatelessWidget {
  final dynamic track;
  final VoidCallback? onTap;

  const CompactMusicCard({
    super.key,
    required this.track,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String title = track['title'] ?? 'Unknown Title';
    final String artist = track['artist'] ?? 'Unknown Artist';
    final String? artworkUrl = track['artworkUrl'];

    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          // Artwork
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: artworkUrl != null
                ? CachedNetworkImage(
                    imageUrl: artworkUrl,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 48,
                      height: 48,
                      color: AppTheme.surfaceColor,
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 48,
                      height: 48,
                      color: AppTheme.surfaceColor,
                      child: const Icon(
                        Icons.music_note,
                        color: AppTheme.textSecondaryColor,
                        size: 20,
                      ),
                    ),
                  )
                : Container(
                    width: 48,
                    height: 48,
                    color: AppTheme.surfaceColor,
                    child: const Icon(
                      Icons.music_note,
                      color: AppTheme.textSecondaryColor,
                      size: 20,
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          
          // Track info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  artist,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
