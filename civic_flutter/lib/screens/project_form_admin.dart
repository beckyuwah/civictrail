import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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

  List<String> apiStates = [];
  bool loadingStates = true;

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  /// Fetch states from API
  Future<void> fetchStates() async {
    setState(() => loadingStates = true);

    try {
      final apiKey = dotenv.env['API_KEY'];
      final baseUrl = dotenv.env['API_URL'];

      if (apiKey == null || baseUrl == null) {
        debugPrint('ENV variables not loaded!');
        setState(() => loadingStates = false);
        return;
      }

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {'X-CSCAPI-KEY': apiKey},
      );

      debugPrint('State API status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        apiStates = data.map((e) => e['name'].toString()).toList();
      } else {
        debugPrint('Failed to fetch states: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error fetching states: $e');
    } finally {
      if (mounted) {
        setState(() => loadingStates = false);
      }
    }
  }

  /// Save project to database
  Future<void> saveProject() async {
    if (!_formKey.currentState!.validate()) return;

    final newProject = Project(
      name: title,
      description: description,
      state: stateName,
      showOnHome: showOnHome,
    );

    try {
      await ProjectDao.addProject(newProject);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Project added successfully')),
      );

      // Close the form to return to ProjectsTab
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding project: $e')),
      );
    }
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
              // Title
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? 'Title required' : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                onChanged: (val) => description = val,
                validator: (val) =>
                    val!.isEmpty ? 'Description required' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // State Autocomplete
              loadingStates
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: CircularProgressIndicator(),
                    )
                  : Autocomplete<String>(
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return apiStates.where((state) => state
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase()));
                      },
                      onSelected: (selection) => stateName = selection,
                      fieldViewBuilder: (context, controller, focusNode,
                          onFieldSubmitted) {
                        return TextFormField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            labelText: 'State',
                            hintText: 'Start typing state name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.map),
                          ),
                          validator: (val) =>
                              val == null || val.isEmpty ? 'State required' : null,
                          onChanged: (val) => stateName = val,
                        );
                      },
                    ),
              const SizedBox(height: 16),

              // Show on Home checkbox
              CheckboxListTile(
                title: const Text('Show on Home Page'),
                value: showOnHome,
                onChanged: (val) {
                  setState(() => showOnHome = val ?? false);
                },
              ),

              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add Project',
                    style: TextStyle(fontSize: 18),
                  ),
                  onPressed: saveProject,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
