class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String location;
  final bool isAdmin;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.location,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'location': location,
      'is_admin': isAdmin ? 1 : 0,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      username: map['username'],
      email: map['email'],
      password: map['password'],
      location: map['location'],
      isAdmin: (map['is_admin'] ?? 0) == 1,
    );
  }
}
