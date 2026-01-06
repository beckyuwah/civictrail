import 'package:flutter/material.dart';
import '../models/project_model.dart';

class ProjectProvider extends ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  void addProject(Project project) {
    _projects.add(project);
    notifyListeners();
  }

  List<Project> getProjectsByState(String state) {
    return _projects.where((project) => project.state == state).toList();
  }

  void loadDummyData() {
    _projects = [
      Project(
          name: "Abia Road Expansion",
          description: "Expanding major roads in Umuahia",
          state: "Abia"),
      Project(
          name: "Lagos Metro Line",
          description: "Construction of metro rail lines in Lagos",
          state: "Lagos"),
      Project(
          name: "Rivers Bridge Project",
          description: "Bridge construction to connect key areas",
          state: "Rivers"),
    ];
    notifyListeners();
  }
}
