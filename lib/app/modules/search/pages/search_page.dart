import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/modules/search/controllers/search_controller.dart' as search_ctrl;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:spotergs/app/core/theme/app_theme.dart';

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
                    onTap: () {
                      Get.toNamed('/music/${music['id']}');
                    },
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
