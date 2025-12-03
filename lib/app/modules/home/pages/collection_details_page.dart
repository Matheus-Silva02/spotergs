import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotergs/app/modules/home/controllers/collection_details_controller.dart';
import 'package:spotergs/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:spotergs/app/core/services/audio_service.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';

class CollectionDetailsPage extends GetView<CollectionDetailsController> {
  const CollectionDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.collection['title'] ?? 'Coleção'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          Obx(() {
            final favController = Get.find<FavoritesController>();
            final collectionId = controller.collection['identifier'] ?? controller.collection['id'] ?? '';
            final isFavorite = favController.isFavorite(collectionId);

            return IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                favController.toggleFavorite(
                  musicIdentifier: collectionId,
                  musicData: controller.collection,
                );
              },
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.tracks.isEmpty) {
          return const Center(
            child: Text('Nenhuma música disponível nesta coleção'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.tracks.length,
          itemBuilder: (context, index) {
            final track = controller.tracks[index];

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap:(){
                 controller.playTrack(track);
                        _showFloatingPlayer(context, track);
              } ,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Album banner
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: AppTheme.cardColor,
                          child: track['banner'] != null && track['banner'].isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: track['banner'],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.music_note),
                                )
                              : const Icon(Icons.music_note),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Music info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track['title'] ?? 'Sem título',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              track['artist'] ?? 'Artista desconhecido',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Play button
                      const Icon(
                        Icons.play_circle_outline,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showFloatingPlayer(BuildContext context, Map<String, dynamic> track) {
    final audioService = Get.find<AudioService>();
    final screenHeight = MediaQuery.of(context).size.height;
    final top = (screenHeight - 250).obs;

    // Remove old overlay if exists
    if (audioService.currentOverlayEntry != null) {
      audioService.currentOverlayEntry!.remove();
    }

    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Obx(() => Positioned(
        top: top.value,
        left: 16,
        right: 16,
        child: GestureDetector(
          onPanUpdate: (details) {
            top.value += details.delta.dy;
            top.value = top.value.clamp(50, screenHeight - 150);
          },
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(20),
            color: AppTheme.surfaceColor,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Album art
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppTheme.cardColor,
                        ),
                        child: track['banner'] != null
                            ? CachedNetworkImage(
                                imageUrl: track['banner'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.music_note),
                              )
                            : const Icon(Icons.music_note),
                      ),
                      const SizedBox(width: 12),
                      // Title and artist
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              track['title'] ?? 'Sem título',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium,
                            ),
                            Text(
                              track['artist'] ?? 'Artista desconhecido',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Close button
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () async {
                          await audioService.stop();
                          entry.remove();
                          audioService.currentOverlayEntry = null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Slider for time
                  Obx(() {
                    final position = audioService.currentPosition.value;
                    final duration = audioService.totalDuration.value;
                    final positionMs = position.inMilliseconds.toDouble();
                    final durationMs = duration.inMilliseconds.toDouble();

                    return Slider(
                      min: 0,
                      max: durationMs > 0 ? durationMs : 1,
                      value: durationMs > 0 ? positionMs.clamp(0, durationMs) : 0,
                      activeColor: AppTheme.primaryColor,
                      inactiveColor: AppTheme.dividerColor,
                      onChanged: (value) {
                        audioService.seek(value.toInt());
                      },
                    );
                  }),
                  // Play/Pause button
                  Obx(() {
                    return IconButton(
                      icon: Icon(
                        audioService.isPlaying.value
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () async {
                        if (audioService.isPlaying.value) {
                          await audioService.pause();
                        } else {
                          await audioService.resume();
                        }
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      )),
    );

    audioService.currentOverlayEntry = entry;
    overlay.insert(entry);
  }
}
