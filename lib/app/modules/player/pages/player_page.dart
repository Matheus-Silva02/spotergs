import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';

class PlayerPage extends GetView<PlayerController> {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Tocando'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        final currentTrack = controller.currentTrack.value;

        if (currentTrack == null) {
          return const Center(
            child: Text('Nenhuma música selecionada'),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // Album art
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppTheme.cardColor,
                  ),
                  child: currentTrack['imageUrl'] != null
                      ? CachedNetworkImage(
                          imageUrl: currentTrack['imageUrl'],
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.music_note),
                        )
                      : const Icon(Icons.music_note, size: 100),
                ),
                const SizedBox(height: 40),
                // Track info
                Text(
                  currentTrack['title'] ?? 'Sem título',
                  style: AppTextStyles.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  currentTrack['artist'] ?? 'Artista desconhecido',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Progress bar
                Obx(() {
                  return Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                        ),
                        child: Slider(
                          value: controller.currentPosition.inSeconds.toDouble(),
                          max: controller.totalDuration.inSeconds.toDouble(),
                          activeColor: AppTheme.primaryColor,
                          inactiveColor: AppTheme.dividerColor,
                          onChanged: (value) {
                            controller.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${controller.currentPosition.inMinutes}:${(controller.currentPosition.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            Text(
                              '${controller.totalDuration.inMinutes}:${(controller.totalDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 40),
                // Controls
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shuffle),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        iconSize: 32,
                        onPressed: () {},
                      ),
                      FloatingActionButton(
                        backgroundColor: AppTheme.primaryColor,
                        child: Icon(
                          controller.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: () {
                          if (controller.isPlaying) {
                            controller.pause();
                          } else {
                            controller.resume();
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        iconSize: 32,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.repeat),
                        onPressed: () {},
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        );
      }),
    );
  }
}
