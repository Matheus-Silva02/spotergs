import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/modules/search/controllers/search_controller.dart' as search_ctrl;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';
import 'package:spotergs/app/core/services/audio_service.dart';

class SearchPage extends GetView<search_ctrl.SearchController> {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Música'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar músicas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppTheme.surfaceColor,
              ),
            ),
          ),
          // Search results
          Expanded(
            child: Obx(() {
              if (controller.isSearching.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Text(
                    controller.searchController.text.isEmpty
                        ? 'Digite para buscar'
                        : 'Nenhuma música encontrada',
                    style: const TextStyle(fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.searchResults.length,
                itemBuilder: (context, index) {
                  final music = controller.searchResults[index];
                  return ListTile(
                    shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                    onTap: () { controller.playTrack(music);
                        _showFloatingPlayer(context, music);},
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Container(
                        width: 56,
                        height: 56,
                        color: AppTheme.cardColor,
                        child: music['imageUrl'] != null
                            ? CachedNetworkImage(
                                imageUrl: music['imageUrl'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.music_note),
                              )
                            : const Icon(Icons.music_note),
                      ),
                    ),
                    title: Text(music['title'] ?? 'Sem título'),
                    subtitle: Text(music['artist'] ?? 'Artista desconhecido'),
                    trailing: Icon(
                      (Icons.play_circle_outline),
                      
                       
                      
                    ),
                   
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showFloatingPlayer(BuildContext context, Map<String, dynamic> music) {
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
                        child: music['imageUrl'] != null
                            ? CachedNetworkImage(
                                imageUrl: music['imageUrl'],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                errorWidget: (context, url, error) => const Icon(Icons.music_note),
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
                              music['title'] ?? 'Sem título',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyMedium,
                            ),
                            Text(
                              music['artist'] ?? 'Artista desconhecido',
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
                        audioService.isPlaying.value ? Icons.pause : Icons.play_arrow,
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
