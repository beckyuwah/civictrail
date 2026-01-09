// test/providers/project_dao_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:civic_flutter/database/civic_flutter_db.dart';
import 'package:civic_flutter/database/project_dao.dart';
import 'package:civic_flutter/models/project_model.dart';

void main() {
  sqfliteFfiInit(); // Initialize FFI
  databaseFactory = databaseFactoryFfi; // Use FFI database factory

  // late AppDatabase appDb;

  setUp(() async {
    // Open an in-memory database for testing
    await AppDatabase.testInstance(); // You can create a special constructor for tests
    await AppDatabase.database; // Initialize tables
  });

  tearDown(() async {
    await AppDatabase.closeDatabase();
  });

  test('Insert and retrieve a project', () async {
    final project = Project(
      id: 1,
      name: 'Integration Test Project',
      description: 'Testing insert',
      state: 'TestState',
      showOnHome: true
    );

    await ProjectDao.addProject(project);

    final projects = await ProjectDao.getProjects();
    expect(projects.length, 1);
    expect(projects.first.name, 'Integration Test Project');
  });

  test('Update project', () async {
    final project = Project(
      id: 1,
      name: 'Old Name',
      description: 'Old Description',
      state: 'OldState',
      showOnHome: false,
    );

    await ProjectDao.addProject(project);

    final updatedProject = Project(
      id: 1,
      name: 'New Name',
      description: 'Updated Description',
      state: 'NewState',
      showOnHome: true,
    );

    await ProjectDao.updateProject(updatedProject);

    final projects = await ProjectDao.getProjects();
    expect(projects.first.name, 'New Name');
    expect(projects.first.state, 'NewState');
  });

  test('Delete project', () async {
    final project = Project(
      id: 1,
      name: 'Delete Me',
      description: 'To be deleted',
      state: 'Test',
      showOnHome: false,
    );

    await ProjectDao.addProject(project);
    await ProjectDao.deleteProject(project.id!);

    final projects = await ProjectDao.getProjects();
    expect(projects, isEmpty);
  });

  test('Get projects by state', () async {
    final project1 = Project(
      id: 1,
      name: 'Project A',
      description: 'Desc A',
      state: 'Abia',
      showOnHome: false,
    );
    final project2 = Project(
      id: 2,
      name: 'Project B',
      description: 'Desc B',
      state: 'Lagos',
      showOnHome: false,
    );

    await ProjectDao.addProject(project1);
    await ProjectDao.addProject(project2);

    final abiaProjects = await ProjectDao.getProjectsByState('Abia');
    expect(abiaProjects.length, 1);
    expect(abiaProjects.first.state, 'Abia');
  });

  test('Search projects by name', () async {
    final project = Project(
      id: 1,
      name: 'Unique Project',
      description: 'Testing search',
      state: 'TestState',
      showOnHome: false,
    );

    await ProjectDao.addProject(project);

    final results = await ProjectDao.searchProjects('Unique');
    expect(results.length, 1);
    expect(results.first.name, 'Unique Project');
  });

  test('Get home projects', () async {
    final project1 = Project(id: 1, name: 'Home 1', description: '', state: 'Test', showOnHome: true);
    final project2 = Project(id: 2, name: 'Home 2', description: '', state: 'Test', showOnHome: true);
    final project3 = Project(id: 3, name: 'No Home', description: '', state: 'Test', showOnHome: false);

    await ProjectDao.addProject(project1);
    await ProjectDao.addProject(project2);
    await ProjectDao.addProject(project3);

    final homeProjects = await ProjectDao.getHomeProjects();
    expect(homeProjects.length, 2);
    expect(homeProjects.every((p) => p.showOnHome == true), isTrue);
  });
}
