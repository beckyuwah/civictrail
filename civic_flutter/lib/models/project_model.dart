// lib/models/project_model.dart
class Project {
  final int? id;
  final String name;
  final String description;
  final String state;
  final bool showOnHome; // Admin curated home projects

  Project({
    this.id,
    required this.name,
    required this.description,
    required this.state,
    this.showOnHome = false,
  });

  /// Convert Project to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'state': state,
      'show_on_home': showOnHome ? 1 : 0, // SQLite doesn't have bool
    };
  }

  /// Create Project from Map retrieved from database
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      state: map['state'] as String,
      showOnHome: (map['show_on_home'] ?? 0) == 1,
    );
  }

  /// Allows creating a copy with some fields updated
  Project copyWith({
    int? id,
    String? name,
    String? description,
    String? state,
    bool? showOnHome,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      state: state ?? this.state,
      showOnHome: showOnHome ?? this.showOnHome,
    );
  }
}
