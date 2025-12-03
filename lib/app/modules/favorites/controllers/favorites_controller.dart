import 'package:get/get.dart';
import 'package:spotergs/app/repositories/favorites_repository.dart';

class FavoritesController extends GetxController {
  final FavoritesRepository _repository = FavoritesRepository();

  RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxSet<String> favoriteIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _repository.getFavorites();

      if (response != null) {
        if (response is List) {
          favorites.value = List<Map<String, dynamic>>.from(
            response.map((item) => item as Map<String, dynamic>),
          );
          // Update favorite IDs set - check both identifier and music_identifier fields
          favoriteIds.value = {
            for (var fav in favorites) 
              (fav['identifier'] ?? fav['music_identifier'] ?? fav['id'] ?? '').toString()
          };
          // Remove empty string if present
          favoriteIds.remove('');
        } else if (response is Map && response['status'] == 'success') {
          // Handle response wrapper format
          final favList = response['favorites'];
          if (favList is List) {
            favorites.value = List<Map<String, dynamic>>.from(
              favList.map((item) => item as Map<String, dynamic>),
            );
            favoriteIds.value = {
              for (var fav in favorites) 
                (fav['identifier'] ?? fav['music_identifier'] ?? fav['id'] ?? '').toString()
            };
            favoriteIds.remove('');
          }
        } else {
          errorMessage.value = 'Erro ao carregar favoritos';
        }
      } else {
        errorMessage.value = 'Erro na conexão';
      }
    } catch (e) {
      errorMessage.value = 'Erro ao carregar favoritos: ${e.toString()}';
      print('Load favorites error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite({
    required String musicIdentifier,
    required Map<String, dynamic> musicData,
  }) async {
    final isFavorite = favoriteIds.contains(musicIdentifier);

    try {
      // Call toggle favorite using FavoritesRepository
      final response = await _repository.addFavorite(
        musicIdentifier: musicIdentifier,
        musicData: musicData,
      );

      if (response != null) {
        if (isFavorite) {
          // Was favorite, now removed
          favoriteIds.remove(musicIdentifier);
          favorites.removeWhere((item) => item['identifier'] == musicIdentifier || item['music_identifier'] == musicIdentifier);
          Get.snackbar(
            'Removido',
            'Removido dos favoritos',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        } else {
          // Was not favorite, now added
          favoriteIds.add(musicIdentifier);
          favorites.add({
            ...musicData,
            'music_identifier': musicIdentifier,
          });
          Get.snackbar(
            'Adicionado',
            'Adicionado aos favoritos',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
        // Reload favorites from server to sync
        await Future.delayed(const Duration(milliseconds: 500));
        await loadFavorites();
      } else {
        errorMessage.value = 'Erro ao alternar favorito';
        Get.snackbar(
          'Erro',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      errorMessage.value = 'Erro: ${e.toString()}';
      Get.snackbar(
        'Erro',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  bool isFavorite(String musicIdentifier) {
    return favoriteIds.contains(musicIdentifier);
  }
}
