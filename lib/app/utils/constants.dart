// file: lib/app/utils/constants.dart

/// Application constants
class Constants {
  // API Configuration
  static const String baseUrl = 'http://10.0.2.2:8000/'; // Change to your backend URL
  static const String wsUrl = 'ws://localhost:3000/ws'; // WebSocket URL

  // API Endpoints
  static const String loginEndpoint = '/user/login';
  static const String registerEndpoint = '/user/register';
  static const String guestLoginEndpoint = '/auth/guest';
  static const String logoutEndpoint = '/auth/logout';
  
  static const String tracksEndpoint = '/buscar_tema/anime';
  static const String trackDetailsEndpoint = '/tracks/{id}';
  static const String searchTracksEndpoint = '/tracks/search';
  static const String favoriteTrackEndpoint = '/tracks/{id}/favorite';
  
  static const String roomsEndpoint = '/rooms';
  static const String createRoomEndpoint = '/rooms/create';
  static const String joinRoomEndpoint = '/rooms/{id}/join';
  static const String leaveRoomEndpoint = '/rooms/{id}/leave';

  // Pagination
  static const int defaultPageSize = 20;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  
  // Player
  static const double playerBottomSheetMinHeight = 80.0;
  static const double playerBottomSheetMaxHeight = 600.0;
  
  // Debounce
  static const Duration searchDebounce = Duration(milliseconds: 300);
  
  // Audio
  static const double maxVolume = 1.0;
  static const double minVolume = 0.0;
  static const double defaultVolume = 0.8;

  // Error Messages
  static const String networkErrorMessage = 'Erro de conexão. Verifique sua internet';
  static const String unknownErrorMessage = 'Erro desconhecido. Tente novamente';
  static const String authErrorMessage = 'Erro de autenticação';
  static const String invalidCredentialsMessage = 'Credenciais inválidas';
}
