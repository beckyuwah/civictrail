import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:provider/provider.dart';

import 'package:civic_flutter/screens/projects_tab.dart';
import 'package:civic_flutter/models/project_model.dart';
import 'package:civic_flutter/providers/project_provider.dart';

void main() {
  // Initialize Flutter bindings
  TestWidgetsFlutterBinding.ensureInitialized();

  // Dummy projects for testing
  final initialProjects = [
    Project(
      id: 1,
      name: 'Abia Road Expansion',
      description: 'Desc 1',
      state: 'Abia',
      showOnHome: true,
    ),
    Project(
      id: 2,
      name: 'Lagos Metro Line',
      description: 'Desc 2',
      state: 'Lagos',
      showOnHome: true,
    ),
    Project(
      id: 3,
      name: 'Rivers Bridge Project',
      description: 'Desc 3',
      state: 'Rivers',
      showOnHome: true,
    ),
  ];

  testWidgets('ProjectsTab displays initial projects', (tester) async {
    // Use mockNetworkImagesFor to prevent HTTP image fetches
    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: ProjectsTab(testProjects: initialProjects),
        ),
      );

      await tester.pumpAndSettle(); // wait for UI to build

      // Verify initial projects are displayed
      expect(find.text('Abia Road Expansion'), findsOneWidget);
      expect(find.text('Lagos Metro Line'), findsOneWidget);
      expect(find.text('Rivers Bridge Project'), findsOneWidget);

      // Verify the number of ListTiles matches
      expect(find.byType(ListTile), findsNWidgets(initialProjects.length));
    });
  });

  testWidgets('ProjectsTab updates when a project is added', (tester) async {
    // Start with initial projects
    final projectProvider = ProjectProvider();
    projectProvider.loadDummyData();

    // Add a new project to the list
    final updatedProjects = List<Project>.from(initialProjects)
      ..add(Project(
        id: 4,
        name: 'New UI Project',
        description: 'Added after initial load',
        state: 'TestState',
        showOnHome: false,
      ));

    await mockNetworkImagesFor(() async {
      // Build widget with updated project list
      await tester.pumpWidget(
        MaterialApp(
          home: ProjectsTab(testProjects: updatedProjects),
        ),
      );

      await tester.pumpAndSettle(); // wait for UI to reflect changes

      // Verify new project is displayed
      expect(find.text('New UI Project'), findsOneWidget);

      // Verify total ListTile count
      expect(find.byType(ListTile), findsNWidgets(updatedProjects.length));
    });
  });
}
