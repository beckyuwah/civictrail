import 'package:flutter/material.dart';
import '../database/project_dao.dart';
import '../models/project_model.dart';
import 'project_form_admin.dart';
import '../services/session.dart';

// class ProjectsTab extends StatefulWidget {

//   const ProjectsTab({super.key});

//   @override
//   State<ProjectsTab> createState() => _ProjectsTabState();
// }
class ProjectsTab extends StatefulWidget {
  final List<Project>? testProjects;

  const ProjectsTab({Key? key, this.testProjects}) : super(key: key);

  @override
  State<ProjectsTab> createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  List<Project> projects = [];
  String searchQuery = '';
  String selectedState = 'All';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProjects();
  }

  Future<void> loadProjects() async {
  setState(() => loading = true);
  List<Project> all;

  // Use testProjects if provided, otherwise load from DB
  if (widget.testProjects != null) {
    all = widget.testProjects!;
  } else {
    all = await ProjectDao.getProjects();
  }

  if (!mounted) return;
  setState(() {
    projects = all;
    loading = false;
  });
}

  Future<void> _confirmDelete(Project project) async {
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
      await ProjectDao.deleteProject(project.id!);
      await loadProjects();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project deleted')),
      );
    }
  }

  // Dynamically compute list of states
  List<String> get states {
    final stateSet = projects.map((p) => p.state).toSet().toList();
    stateSet.sort();
    return ['All', ...stateSet];
  }

  // Filter projects based on search query + selected state
  List<Project> get filteredProjects {
    return projects.where((p) {
      final matchesSearch =
          p.name.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesState = selectedState == 'All' || p.state == selectedState;
      return matchesSearch && matchesState;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Projects'),
        actions: [
          if (Session.isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Project',
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AddProjectForm(),
                  ),
                );
                await loadProjects(); // refresh after adding
              },
            ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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

                // Projects list
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
                                trailing: Session.isAdmin
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Show on Home checkbox
                                          Checkbox(
                                            value: project.showOnHome,
                                            onChanged: (val) async {
                                              final updated = project.copyWith(
                                                  showOnHome: val ?? false);
                                              await ProjectDao.updateProject(
                                                  updated);
                                              await loadProjects();
                                            },
                                          ),

                                          // Delete icon
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _confirmDelete(project),
                                          ),
                                        ],
                                      )
                                    : Text(
                                        project.state,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
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
