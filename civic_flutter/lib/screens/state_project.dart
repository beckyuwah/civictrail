import 'package:flutter/material.dart';
import '../data/projects_data.dart';

class ProjectsByStateScreen extends StatelessWidget {
  final String stateName;

  const ProjectsByStateScreen({super.key, required this.stateName});

  @override
  Widget build(BuildContext context) {
    final projects =
        allProjects.where((p) => p.state == stateName).toList();

    return Scaffold(
      appBar: AppBar(title: Text('$stateName Projects')),
      body: projects.isEmpty
          ? const Center(child: Text('No projects available'))
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(project.name),
                    subtitle: Text(project.description),
                  ),
                );
              },
            ),
    );
  }
}
