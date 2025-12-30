import 'package:flutter/material.dart';
import '../data/projects_data.dart';

class ProjectsTab extends StatefulWidget {
  const ProjectsTab({super.key});

  @override
  State<ProjectsTab> createState() => _ProjectsTabState();
}

class _ProjectsTabState extends State<ProjectsTab> {
  String searchQuery = '';
  String selectedState = 'All';

  List<String> get states {
    final stateSet = allProjects.map((p) => p.state).toSet().toList();
    stateSet.sort();
    return ['All', ...stateSet];
  }

  List get filteredProjects {
    return allProjects.where((project) {
      final matchesSearch = project.name
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesState =
          selectedState == 'All' || project.state == selectedState;

      return matchesSearch && matchesState;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Projects')),
      body: Column(
        children: [
          // 🔍 Search box
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

          // 🗂 State filter
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

          // 📋 Project list
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
                          trailing: Text(
                            project.state,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
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
