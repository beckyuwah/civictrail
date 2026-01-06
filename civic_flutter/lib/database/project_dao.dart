import 'civic_flutter_db.dart';
import '../models/project_model.dart';
import 'package:sqflite/sqflite.dart';

class ProjectDao {
  /// Add a project to the database
  static Future<int> addProject(Project project) async {
    final db = await AppDatabase.database;

    // Insert project into DB
    return db.insert(
      'projects',
      project.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all projects from the database
  static Future<List<Project>> getProjects() async {
    final db = await AppDatabase.database;
    final result = await db.query(
      'projects',
      orderBy: 'id DESC',
    );

    return result.map((row) => Project.fromMap(row)).toList();
  }

  /// Update an existing project
  static Future<int> updateProject(Project project) async {
    final db = await AppDatabase.database;
    return db.update(
      'projects',
      project.toMap(),
      where: 'id = ?',
      whereArgs: [project.id],
    );
  }

  /// Delete a project
  static Future<int> deleteProject(int id) async {
    final db = await AppDatabase.database;
    return db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get projects filtered by state
  static Future<List<Project>> getProjectsByState(String state) async {
    final db = await AppDatabase.database;
    final result = await db.query(
      'projects',
      where: 'state = ?',
      whereArgs: [state],
      orderBy: 'name ASC',
    );
    return result.map((row) => Project.fromMap(row)).toList();
  }

  /// Search projects by name
  static Future<List<Project>> searchProjects(String query) async {
    final db = await AppDatabase.database;
    final result = await db.query(
      'projects',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'name ASC',
    );
    return result.map((row) => Project.fromMap(row)).toList();
  }

  /// Get projects flagged to show on home page (max 5)
  static Future<List<Project>> getHomeProjects() async {
    final db = await AppDatabase.database;
    final result = await db.query(
      'projects',
      where: 'show_on_home = ?',
      whereArgs: [1], // 1 = true
      orderBy: 'id DESC',
      limit: 5,
    );

    return result.map((row) => Project.fromMap(row)).toList();
  }
}
