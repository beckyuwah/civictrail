import 'package:flutter/material.dart';
import '../database/project_dao.dart';
import '../models/project_model.dart';

class AddProjectForm extends StatefulWidget {
  const AddProjectForm({super.key});

  @override
  State<AddProjectForm> createState() => _AddProjectFormState();
}

class _AddProjectFormState extends State<AddProjectForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';
  String stateName = '';

  bool showOnHome = false; 

  Future<void> saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    await ProjectDao.addProject(Project(
      name: title,
      description: description,
      state: stateName,
      showOnHome: showOnHome,
    ));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project added successfully')),
    );

    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Project')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? 'Title required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (val) => description = val,
                validator: (val) => val!.isEmpty ? 'Description required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'State'),
                onChanged: (val) => stateName = val,
                validator: (val) => val!.isEmpty ? 'State required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: saveProject,
                child: const Text('Add Project'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
