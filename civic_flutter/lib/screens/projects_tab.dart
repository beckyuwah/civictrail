import 'package:flutter/material.dart';
import '../database/project_dao.dart';
import '../models/project_model.dart';
import 'project_form_admin.dart';
import '../services/session.dart';

class ProjectsTab extends StatefulWidget {
  const ProjectsTab({super.key});

  @override
  State<ProjectsTab> createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  List<Project> projects = [];
  String searchQuery = '';
  String selectedState = 'All';

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
    final all = await ProjectDao.getProjects();
    if (!mounted) return;
    setState(() {
      projects = all;
    });
  }

  Future<void> _confirmDelete(int projectId) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Delete Project'),
      content: const Text('Are you sure you want to delete this project?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );

  if (confirm == true) {
    await ProjectDao.deleteProject(projectId);
    loadProjects();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project deleted')),
    );
  }
}
  // Compute list of states dynamically
  List<String> get states {
    final stateSet = projects.map((p) => p.state).toSet().toList();
    stateSet.sort();
    return ['All', ...stateSet];
  }

  // Filter projects based on search and selected state
  List<Project> get filteredProjects {
    return projects.where((p) {
      final matchesSearch =
          p.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesState =
          selectedState == 'All' || p.state == selectedState;
      return matchesSearch && matchesState;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Projects'),
        actions: [
          // Show Add Project button only for admin
          if (Session.isLoggedIn && Session.username == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddProjectForm(),
                  ),
                );
                loadProjects(); // Refresh projects after adding
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // State filter dropdown
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              initialValue: selectedState,
              decoration: const InputDecoration(
                labelText: 'Filter by State',
                border: OutlineInputBorder(),
              ),
              items: states
                  .map(
                    (state) => DropdownMenuItem(
                      value: state,
                      child: Text(state),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedState = value!;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          // Project list
          Expanded(
            child: filteredProjects.isEmpty
                ? const Center(child: Text('No projects found'))
                : ListView.builder(
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = filteredProjects[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(project.name),
                          subtitle: Text(project.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                project.state,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (Session.username == 'admin')
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmDelete(project.id!),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
