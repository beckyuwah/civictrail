// lib/providers/project_provider.dart

import 'package:flutter/material.dart';
import '../models/project_model.dart';

class ProjectProvider extends ChangeNotifier {
  // Private list to store projects
  List<Project> _projects = [];

  // Public getter
  List<Project> get projects => _projects;

  // Add a project
  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  // Remove a project by ID
  void removeProject(Project project) {
    _projects.removeWhere((p) => p.id == project.id);
    notifyListeners();
  }

  // Get project by ID (returns null if not found)
  Project? getProjectById(int id) {
    try {
      return _projects.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Filter projects by state
  List<Project> getProjectsByState(String state) {
    return _projects.where((p) => p.state == state).toList();
  }

  // Load some dummy projects for testing
  void loadDummyData() {
    _projects = [
      Project(
        id: 1,
        name: "Abia Road Expansion",
        description: "Expanding major roads in Umuahia",
        state: "Abia",
      ),
      Project(
        id: 2,
        name: "Lagos Metro Line",
        description: "Construction of metro rail lines in Lagos",
        state: "Lagos",
      ),
      Project(
        id: 3,
        name: "Rivers Bridge Project",
        description: "Bridge construction to connect key areas",
        state: "Rivers",
      ),
    ];
    notifyListeners();
  }
}
