import 'package:flutter_test/flutter_test.dart';
import 'package:civic_flutter/providers/project_provider.dart';
import 'package:civic_flutter/models/project_model.dart';

void main() {
  group('ProjectProvider Unit Tests', () {
    late ProjectProvider projectProvider;

    setUp(() {
      // Fresh provider for each test
      projectProvider = ProjectProvider();
    });

    test('initial state should contain an empty project list', () {
      expect(projectProvider.projects, isEmpty);
    });

    test('addProject adds a project correctly', () {
      final project = Project(id: 1, name: 'Test Project', description: '', state: '');
      projectProvider.addProject(project);

      expect(projectProvider.projects.length, 1);
      expect(projectProvider.projects.first.name, 'Test Project');
    });

    test('removeProject removes a project correctly', () {
      final project = Project(id: 1, name: 'Test Project', description: '', state: '');
      projectProvider.addProject(project);
      projectProvider.removeProject(project);

      expect(projectProvider.projects, isEmpty);
    });

    test('getProjectById returns correct project', () {
      final project = Project(id: 1, name: 'Test Project', description: '', state: '');
      projectProvider.addProject(project);

      final result = projectProvider.getProjectById(1);
      expect(result, isNotNull);
      expect(result!.name, 'Test Project');
    });

    test('getProjectById returns null for missing project', () {
      final result = projectProvider.getProjectById(999);
      expect(result, isNull);
    });
  });
}