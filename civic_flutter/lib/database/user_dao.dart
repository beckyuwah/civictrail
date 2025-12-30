import 'civic_flutter_db.dart';
import '../models/user.dart';

class UserDao {
  static Future<int> registerUser(User user) async {
    final db = await AppDatabase.database;
    return db.insert('users', user.toMap());
  }

  static Future<User?> login(String email, String password) async {
    final db = await AppDatabase.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User(
        id: result.first['id'] as int,
        username: result.first['username'] as String,
        email: result.first['email'] as String,
        password: result.first['password'] as String,
      );
    }
    return null;
  }
}
