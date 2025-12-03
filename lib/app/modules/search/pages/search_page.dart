import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/modules/search/controllers/search_controller.dart' as search_ctrl;
import 'package:spotergs/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';
import 'package:spotergs/app/core/theme/app_text_styles.dart';

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
                  return _SearchResultItem(
                    music: music,
                    index: index,
                    controller: controller,
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final dynamic music;
  final int index;
  final search_ctrl.SearchController controller;

  const _SearchResultItem({
    required this.music,
    required this.index,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final musicId = music['identifier'] ?? 'unknown_$index';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Get.toNamed(
            '/collection/${music['identifier']}',
            arguments: music,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppTheme.cardColor,
                  child: music['imageUrl'] != null
                      ? CachedNetworkImage(
                          imageUrl: music['imageUrl'],
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music['title'] ?? 'Sem título',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 4),
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
              Column(
                children: [
                  const Icon(
                    Icons.play_circle_outline,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  _FavoriteIcon(
                    musicId: musicId,
                    onTap: () {
                      controller.toggleFavorite(music, index);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FavoriteIcon extends StatefulWidget {
  final String musicId;
  final VoidCallback onTap;

  const _FavoriteIcon({
    required this.musicId,
    required this.onTap,
  });

  @override
  State<_FavoriteIcon> createState() => _FavoriteIconState();
}

class _FavoriteIconState extends State<_FavoriteIcon> {
  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoritesController>();
    final isFavorite = favController.isFavorite(widget.musicId);

    return GestureDetector(
      onTap: () {
        widget.onTap();
        setState(() {});
      },
      child: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
        size: 24,
      ),
    );
  }
}
