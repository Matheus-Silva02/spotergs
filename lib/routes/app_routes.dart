// file: lib/routes/app_routes.dart

/// Application routes
abstract class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String search = '/search';
  static const String player = '/player';
  static const String musicDetails = '/music/:id';
  static const String listenRoom = '/listen/room/:id';
  static const String profile = '/profile';
  static const String favorites = '/favorites';
  static const String collectionDetails = '/collection/:identifier';
}

