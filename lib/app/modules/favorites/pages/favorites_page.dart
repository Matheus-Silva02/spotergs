import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotergs/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';

class FavoritesPage extends GetView<FavoritesController> {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: AppTheme.textSecondaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma coleção nos favoritos',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final favorite = controller.favorites[index];
            // Check multiple identifier fields as returned by IAService
            final favoriteId = favorite['identifier'] ?? 
                              favorite['music_identifier'] ?? 
                              favorite['id'] ?? 
                              'unknown_$index';

            // Detectar se é uma coleção ou música
            final isCollection = favorite['url'] == null && favorite['artist'] == null;

            return Obx(() {
              final isFav = controller.isFavorite(favoriteId);
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 56,
                    height: 56,
                    color: AppTheme.cardColor,
                    child: favorite['banner'] != null
                        ? CachedNetworkImage(
                            imageUrl: favorite['banner'],
                            fit: BoxFit.cover,
                          )
                        : favorite['imageUrl'] != null
                            ? CachedNetworkImage(
                                imageUrl: favorite['imageUrl'],
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.music_note),
                  ),
                ),
                title: Text(favorite['title'] ?? 'Sem título'),
                subtitle: Text(
                  favorite['artist'] ?? favorite['description'] ?? 'Desconhecido',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null,
                  ),
                  onPressed: () {
                    controller.toggleFavorite(
                      musicIdentifier: favoriteId,
                      musicData: favorite,
                    );
                  },
                ),
                onTap: () {
                  Get.toNamed(
                    '/collection/$favoriteId',
                    arguments: favorite,
                  );
                },
              );
            });
          },
        );
      }),
    );
  }

}
