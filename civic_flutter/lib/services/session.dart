// lib/services/session.dart
import 'package:logging/logging.dart';

class Session {
  static int? userId;
  static String? username;

  /// Logger instance
  static final Logger _logger = Logger('Session');

  /// Returns true if a user is logged in
  static bool get isLoggedIn => userId != null;

  /// Returns true if the current user is admin
  static bool get isAdmin => username?.toLowerCase() == 'admin';

  /// Log in the user
  static void login({
    required int id,
    required String name,
  }) {
    userId = id;
    username = name;
    _logger.info('User $username logged in with id $userId');
  }

  /// Log out the current user
  static void logout() {
    _logger.info('User $username logged out');
    userId = null;
    username = null;
  }
}
