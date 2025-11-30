import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';

class MusicDetailsPage extends GetView<PlayerController> {
  const MusicDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Música'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        // For demo purposes, using the current track
        final music = controller.currentTrack.value;

        if (music == null) {
          return const Center(
            child: Text('Nenhuma música selecionada'),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Album art
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppTheme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.backgroundColor.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: music['imageUrl'] != null
                        ? CachedNetworkImage(
                            imageUrl: music['imageUrl'],
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.music_note, size: 100),
                          )
                        : const Icon(Icons.music_note, size: 100),
                  ),
                ),
                const SizedBox(height: 40),
                // Title
                Text(
                  music['title'] ?? 'Sem título',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 8),
                // Artist
                Text(
                  music['artist'] ?? 'Artista desconhecido',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                // Duration and Plays
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Duração',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${controller.totalDuration.inMinutes}:${(controller.totalDuration.inSeconds % 60).toString().padLeft(2, '0')}',
                          style: AppTextStyles.titleMedium,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reproduções',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${music['plays'] ?? 0}',
                          style: AppTextStyles.titleMedium,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Data',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppTheme.textSecondaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          music['releaseDate'] ?? '---',
                          style: AppTextStyles.titleMedium,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Description
                Text(
                  'Descrição',
                  style: AppTextStyles.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  music['description'] ?? 'Sem descrição disponível',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),
                // Action buttons
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (controller.isPlaying) {
                        controller.pause();
                      } else {
                        controller.resume();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    icon: Obx(() {
                      return Icon(
                        controller.isPlaying ? Icons.pause : Icons.play_arrow,
                      );
                    }),
                    label: Obx(() {
                      return Text(
                        controller.isPlaying ? 'Pausar' : 'Tocar',
                        style: const TextStyle(fontSize: 16),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Adicionar à Favoritos'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
