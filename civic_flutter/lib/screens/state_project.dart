import 'package:flutter/material.dart';
import '../database/project_dao.dart';
import '../models/project_model.dart';

class ProjectsByStateScreen extends StatefulWidget {
  final String stateName;

  const ProjectsByStateScreen({
    super.key,
    required this.stateName,
  });

  @override
  State<ProjectsByStateScreen> createState() => _ProjectsByStateScreenState();
}

class _ProjectsByStateScreenState extends State<ProjectsByStateScreen> {
  List<Project> projects = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    final data = await ProjectDao.getProjectsByState(widget.stateName);

    if (!mounted) return;

    setState(() {
      projects = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.stateName} Projects'),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : projects.isEmpty
              ? const Center(child: Text('No projects available'))
              : ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    final project = projects[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(
                          project.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(project.description),
                      ),
                    );
                  },
                ),
    );
  }
}
