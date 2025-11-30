// file: lib/app/modules/search/controllers/search_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/repositories/music_repository.dart';
import 'package:spotergs/app/modules/player/controllers/player_controller.dart';
import 'package:spotergs/app/utils/constants.dart';

/// Controller for Search module
class SearchController extends GetxController {
  final MusicRepository _musicRepository = MusicRepository();
  final PlayerController _playerController = Get.find<PlayerController>();

  // Text editing controller
  final searchController = TextEditingController();

  // Observable state
  final searchResults = <dynamic>[].obs;
  final isSearching = false.obs;
  final searchQuery = ''.obs;

  Timer? _debounceTimer;

  @override
  void onInit() {
    super.onInit();
    // Listen to search query changes
    ever(searchQuery, (_) => _performSearch());
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  /// Handle search input with debounce
  void onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Constants.searchDebounce, () {
      searchQuery.value = value;
    });
  }

  /// Perform search
  Future<void> _performSearch() async {
    final query = searchQuery.value.trim();

    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    if (query.length < 2) {
      return; // Minimum 2 characters to search
    }

    isSearching.value = true;

    try {
      final response = await _musicRepository.getTracksByTheme(query);

      if (response != null) {
        List<dynamic> rawTracks;
        if (response is List) {
          rawTracks = response;
        } else if (response is Map && response['tracks'] != null) {
          rawTracks = response['tracks'];
        } else {
          rawTracks = [];
        }
        final List<dynamic> tracks = rawTracks.map((track) {
          return {
            'id': track['identifier'] ?? '',
            'title': track['title'] ?? 'Sem título',
            'artist': track['artist'] is List ? (track['artist'] as List).join(', ') : track['artist'] ?? 'Desconhecido',
            'imageUrl': track['banner'] ?? '',
            'audioUrl': '',
          };
        }).toList();
        searchResults.value = tracks;
      }
    } catch (e) {
      print('Search error: $e');
      Get.snackbar(
        'Erro',
        'Falha ao buscar músicas',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSearching.value = false;
    }
  }

  /// Clear search
  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    searchResults.clear();
  }

  /// Play track
  void playTrack(dynamic track) {
    final String? audioUrl = track['audioUrl'];
    final String? trackId = track['id'];

    if (audioUrl != null && trackId != null) {
      _playerController.playTrack(track, queue: searchResults);
    } else {
      Get.snackbar(
        'Erro',
        'URL de áudio não disponível',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Toggle favorite
  Future<void> toggleFavorite(String trackId, int index) async {
    try {
      final response = await _musicRepository.toggleFavorite(trackId);

      if (response != null) {
        final bool isFavorite = response['isFavorite'] ?? false;
        searchResults[index]['isFavorite'] = isFavorite;
        searchResults.refresh();
      }
    } catch (e) {
      print('Toggle favorite error: $e');
    }
  }
}
