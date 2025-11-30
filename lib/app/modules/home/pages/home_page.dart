import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/modules/home/controllers/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotergs/app/core/services/audio_service.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify UERGS'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GestureDetector(
              onTap: () => Get.toNamed('/profile'),
              child: const CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Icon(Icons.person),
              ),
            ),
          ),
        ],
      ),
      
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recently played
                const Text(
                  'Teste',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: Obx(() {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.tracks.length > 5 ? 5 : controller.tracks.length,
                      itemBuilder: (context, index) {
                        final track = controller.tracks[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed('/music/${track['id']}');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      color: AppTheme.cardColor,
                                    child: track['imageUrl'] != null
                                        ? CachedNetworkImage(
                                            imageUrl: track['imageUrl'],
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget: (context, url, error) =>
                                                const Icon(Icons.music_note),
                                          )
                                        : const Icon(Icons.music_note),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    track['title'] ?? 'Sem título',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.titleMedium,
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    track['artist'] ?? 'Artista desconhecido',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 32),
                // All tracks
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Todas as Músicas',
                      style: AppTextStyles.headlineMedium,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed('/search'),
                      child: Text(
                        'Ver mais',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.tracks.length,
                    itemBuilder: (context, index) {
                      final track = controller.tracks[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Container(
                            width: 56,
                            height: 56,
                            color: AppTheme.cardColor,
                            child: track['imageUrl'] != null
                                ? CachedNetworkImage(
                                    imageUrl: track['imageUrl'],
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(Icons.music_note),
                          ),
                        ),
                        title: Text(track['title'] ?? 'Sem título'),
                        subtitle: Text(
                          track['artist'] ?? 'Artista desconhecido',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.play_circle_outline),
                          onPressed: () {
                            Get.toNamed('/player');
                          },
                        ),
                        onTap: () {
                          Get.toNamed('/music/${track['id']}');
                        },
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Biblioteca',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Get.toNamed('/search');
              break;
            case 2:
              Get.snackbar('Favoritos', 'Página de favoritos em desenvolvimento');
              break;
            case 3:
              Get.snackbar('Biblioteca', 'Página de biblioteca em desenvolvimento');
              break;
          }
        },
      ),
    );
  }

  void _showPlayerModal(BuildContext context) {
    final audioService = Get.find<AudioService>();
    final url = "https://archive.org/download/1BadAppleQuarterDontSpoilTheWholeStockDTNS3440/3440%201%20Bad%20Apple%20Quarter%20Don't%20Spoil.mp3";

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              color: AppTheme.surfaceColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Icon(Icons.music_note, size: 64, color: AppTheme.primaryColor),
                    const SizedBox(height: 16),
                    const Text(
                      'Bad Apple!! [Tracy vs. Astronomical Remix]',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 8),
                     Text(
                      'Archive.org',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Time display and slider
                    Obx(() {
                      final position = audioService.currentPosition.value;
                      final duration = audioService.totalDuration.value;
                      final positionMs = position.inMilliseconds.toDouble();
                      final durationMs = duration.inMilliseconds.toDouble();

                      return Column(
                        children: [
                          Slider(
                            min: 0,
                            max: durationMs > 0 ? durationMs : 1,
                            value: durationMs > 0 ? positionMs.clamp(0, durationMs) : 0,
                            activeColor: AppTheme.primaryColor,
                            inactiveColor: AppTheme.dividerColor,
                            onChanged: (value) {
                              audioService.seek(value.toInt());
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                                Text(
                                  '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppTheme.textPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),
                    // Play/Pause button
                    Obx(() {
                      return ElevatedButton(
                        onPressed: () async {
                          if (audioService.isPlaying.value) {
                            await audioService.pause();
                          } else {
                            if (!audioService.hasAudio) {
                              await audioService.play(url, trackId: 'bad_apple_10');
                            } else {
                              await audioService.resume();
                            }
                          }
                        },
                        child: Icon(
                          audioService.isPlaying.value ? Icons.pause : Icons.play_arrow,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}