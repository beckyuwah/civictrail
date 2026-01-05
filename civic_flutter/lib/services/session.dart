import '../models/user.dart';

class Session {
  static User? _currentUser;

  static User? get currentUser => _currentUser;

  static bool get isLoggedIn => _currentUser != null;
  static bool get isAdmin => _currentUser?.isAdmin ?? false;

  static void login(User user) {
    _currentUser = user;
  }

  static void logout() {
    _currentUser = null;
  }
}
