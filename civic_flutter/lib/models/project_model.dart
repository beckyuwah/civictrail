class Project {
  final int? id; // nullable for new projects
  final String name;
  final String description;
  final String state;

  Project({
    this.id,
    required this.name,
    required this.description,
    required this.state,
  });

  // Convert Project instance to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id, // can be null, SQLite will handle AUTOINCREMENT
      'name': name,
      'description': description,
      'state': state,
    };
  }

  // Optional: create Project from Map (from SQLite)
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      state: map['state'] as String,
    );
  }
}
