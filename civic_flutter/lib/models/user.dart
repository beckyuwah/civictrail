// lib/models/user.dart

class User {
  int? id;
  String username;
  String email;
  String password;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
  });

  /// Convert User object to Map (for inserting/updating SQLite)
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  /// Create User object from Map (from SQLite query)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int?,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }
}
