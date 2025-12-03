import 'package:get/get.dart';
import 'package:spotergs/app/repositories/music_repository.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';
import 'package:spotergs/app/modules/favorites/controllers/favorites_controller.dart';

/// Controller for Collection Details
class CollectionDetailsController extends GetxController {
  final MusicRepository _musicRepository = MusicRepository();
  final PlayerController _playerController = Get.find<PlayerController>();

  // Observable state
  final tracks = <dynamic>[].obs;
  final isLoading = false.obs;
  late dynamic collection;

  @override
  void onInit() {
    super.onInit();
    collection = Get.arguments ?? {};
    loadCollectionTracks();
  }

  /// Load tracks from collection
  Future<void> loadCollectionTracks() async {
    isLoading.value = true;
    try {
      final identifier = collection['identifier'] ?? '';
      if (identifier.isEmpty) {
        Get.snackbar(
          'Erro',
          'Identificador da coleção não disponível',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final response = await _musicRepository.getCollectionDetails(identifier);
      List<dynamic> rawTracks;
      rawTracks = response;
      final List<dynamic> processedTracks = rawTracks.map((track) {
          return {
            'identifier': track['identifier'] ?? '',
            'title': track['title'] ?? 'Sem título',
            'artist': track['artist']?? 'Desconhecido',
            'banner': track['banner'] ?? '',
            'url': track['url'],
          };
        }).toList();

        tracks.value = processedTracks;
      
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao carregar músicas da coleção',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  
  void playTrack(dynamic track) async {
    final String? trackId = track['id'] ?? track['identifier'];

    if (trackId == null || trackId.isEmpty) {
      Get.snackbar(
        'Erro',
        'ID da música não disponível',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final urlResponse = track['url'];
      if (urlResponse != null) {
        String url = '';
        
       
          url = urlResponse;
          _playerController.playTrack(track, url:url);
      } 
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Falha ao obter URL de áudio',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Toggle favorite
  Future<void> toggleFavorite(dynamic track, int index) async {
    try {
      final favController = Get.find<FavoritesController>();
      final trackId = track['id'] ?? '';
      final musicData = {
        'identifier': trackId,
        'title': track['title'] ?? '',
        'artist': track['artist'] ?? '',
        'banner': track['imageUrl'] ?? '',
      };
      await favController.toggleFavorite(
        musicIdentifier: trackId,
        musicData: musicData,
      );
      tracks.refresh();

      Get.snackbar(
        'Sucesso',
        favController.isFavorite(trackId) ? 'Adicionado aos favoritos' : 'Removido dos favoritos',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Toggle favorite error: $e');
      Get.snackbar(
        'Erro',
        'Falha ao atualizar favorito',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
