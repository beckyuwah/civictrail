import 'package:sqflite/sqflite.dart';
import 'civic_flutter_db.dart';
import '../models/project_model.dart';

class ProjectDao {
  /// Add a project to the database
  static Future<int> addProject(Project project) async {
    final db = await AppDatabase.database;
    return db.insert('projects', project.toMap());
  }

  /// Get all projects from the database
  static Future<List<Project>> getProjects() async {
    final db = await AppDatabase.database;
    final result = await db.query('projects', orderBy: 'name ASC');
    return result.map((row) => Project.fromMap(row)).toList();

  }
  static Future<void> deleteProject(int id) async {
    final db = await AppDatabase.database;
    await db.delete(
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
    return result.map((row) => Project(
      id: row['id'] as int?,
      name: row['name'] as String,
      description: row['description'] as String,
      state: row['state'] as String,
    )).toList();
  }

  static Future<List<Project>> getHomeProjects() async {
    final db = await AppDatabase.database;
    final result = await db.query(
      'projects',
      where: 'show_on_home = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
      limit: 5,
    );

    return result.map((e) => Project.fromMap(e)).toList();
  }

}
