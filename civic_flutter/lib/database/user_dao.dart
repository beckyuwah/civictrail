import 'civic_flutter_db.dart';
import '../models/user.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  static Future<int> registerUser(User user) async {
    final db = await AppDatabase.database;

    // Count existing users
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM users');
    final count = Sqflite.firstIntValue(result) ?? 0;

    // First user becomes admin
    final isAdmin = count == 0 ? 1 : 0;

    return db.insert(
      'users',
      {
        'username': user.username,
        'email': user.email,
        'password': user.password,
        'location': user.location,
        'is_admin': isAdmin,
      },
    );
  }

  static Future<User?> login(String email, String password) async {
    final db = await AppDatabase.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isNotEmpty) {
      final row = result.first;

      return User(
        id: row['id'] as int,
        username: row['username'] as String,
        email: row['email'] as String,
        password: row['password'] as String,
        location: row['location']?.toString() ?? '',
        isAdmin: (row['is_admin'] as int) == 1,
      );
    }
    return null;
  }
}
