import 'package:flutter/material.dart';
import '../data/projects_data.dart';

class ProjectsTab extends StatelessWidget {
  const ProjectsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Projects')),
      body: ListView.builder(
        itemCount: allProjects.length,
        itemBuilder: (context, index) {
          final project = allProjects[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(project.name),
              subtitle: Text(project.description),
              trailing: Text(project.state),
            ),
          );
        },
      ),
    );
  }
}

