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
                              // Removed navigation to details page
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
                            controller.playTrack(track);
                            _showFloatingPlayer(context, track);
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
                        child: track['imageUrl'] != null
                            ? CachedNetworkImage(
                                imageUrl: track['imageUrl'],
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