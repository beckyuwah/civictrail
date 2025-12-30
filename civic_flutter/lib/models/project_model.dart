class Project {
  final int? id;
  final String name;
  final String description;
  final String state;
  final bool showOnHome; // ✅ NEW

  Project({
    this.id,
    required this.name,
    required this.description,
    required this.state,
    this.showOnHome = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'state': state,
      'show_on_home': showOnHome ? 1 : 0,
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      state: map['state'],
      showOnHome: map['show_on_home'] == 1,
    );
  }
}
