import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/modules/home/controllers/home_controller.dart';
import 'package:spotergs/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:spotergs/app/repositories/music_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotergs/app/core/services/audio_service.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify UERGS'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
         
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
                  'Coleções mais populares',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: FutureBuilder<dynamic>(
                    future: MusicRepository().getPopularCollections(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(child: Text('Nenhuma coleção disponível'));
                      }

                      List<dynamic> collections;
                      final response = snapshot.data;
                      if (response is List) {
                        collections = response;
                      } else {
                        collections = [];
                      }

                      if (collections.isEmpty) {
                        return const Center(child: Text('Nenhuma coleção disponível'));
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: collections.length > 5 ? 5 : collections.length,
                        itemBuilder: (context, index) {
                          final collection = collections[index];
                          final collectionId = collection['identifier'] ?? collection['id'] ?? '';

                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Obx(() {
                              final favController = Get.find<FavoritesController>();
                              final isFavorite = favController.isFavorite(collectionId);

                              return Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => Get.toNamed(
                                      '/collection/$collectionId',
                                      arguments: collection,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Container(
                                            width: 150,
                                            height: 150,
                                            color: AppTheme.cardColor,
                                            child: (collection['banner'] != null &&
                                                    collection['banner'].isNotEmpty)
                                                ? CachedNetworkImage(
                                                    imageUrl: collection['banner'],
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, url) =>
                                                        const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                    errorWidget: (context, url, error) =>
                                                        const Icon(Icons.image_not_supported),
                                                  )
                                                : const Icon(Icons.image_not_supported),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          width: 150,
                                          child: Text(
                                            collection['title'] ?? 'Sem título',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: AppTextStyles.titleMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        favController.toggleFavorite(
                                          musicIdentifier: collectionId,
                                          musicData: collection,
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.5),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(6),
                                        child: Icon(
                                          isFavorite ? Icons.favorite : Icons.favorite_border,
                                          color: isFavorite ? Colors.red : Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          );
                        },
                      );
                    },
                  ),
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
                      // Use 'identifier' from IAService (music_identifier in DB)
                      final musicId = track['identifier'] ?? track['id'] ?? 'unknown_$index';
                      
                      return Obx(() {
                        final favController = Get.find<FavoritesController>();
                        final isFavorite = favController.isFavorite(musicId);
                        
                        return ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          onTap: () {
                            controller.playTrack(track);
                                  _showFloatingPlayer(context, track);
                          },
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                                onPressed: () {
                                  favController.toggleFavorite(
                                    musicIdentifier: musicId,
                                    musicData: track,
                                  );
                                },
                              ),
                              Icon(
                              (Icons.play_circle_outline),
                               
                              ),
                            ],
                          ),
                          
                        );
                      });
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
          
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Get.toNamed('/search');
              break;
            case 2:
              Get.toNamed('/favorites');
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