import 'package:flutter/material.dart';
import '../services/session.dart';
import '../database/project_dao.dart';
import '../models/project_model.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Add these variables
  List<Project> homeProjects = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadHomeProjects();
  }

  Future<void> loadHomeProjects() async {
    final projects = await ProjectDao.getHomeProjects(); // projects where show_on_home = 1
    if (!mounted) return;
    setState(() {
      homeProjects = projects;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('CivicTrail'),
        elevation: 0,
        actions: [
          if (Session.isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(Session.username!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          // if (Session.isAdmin)
          //   IconButton(
          //     icon: const Icon(Icons.admin_panel_settings),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) => const AdminProjectsScreen(),
          //         ),
          //       );
          //     },
          //   ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _NewsCarousel(),
          const SizedBox(height: 24),
          _LatestProjects(
            projects: homeProjects,
            loading: loading,
          ),
          const SizedBox(height: 24),
          const _EngageSection(),
        ],
      ),
    );
  }
}


class _NewsCarousel extends StatelessWidget {
  const _NewsCarousel();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'News & Updates',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: 3,
            controller: PageController(viewportFraction: 0.9),
            itemBuilder: (context, index) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(right: 12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://picsum.photos/600/300?random=$index',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6 ),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          'Admin Approved Civic Update',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LatestProjects extends StatelessWidget {
  final List<Project> projects;
  final bool loading;

  const _LatestProjects({
    required this.projects,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (projects.isEmpty) {
      return const Text('No featured projects yet');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Latest Projects',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...projects.map(
          (project) => Card(
            child: ListTile(
              title: Text(project.name),
              subtitle: Text(project.description),
              trailing: Text(project.state),
            ),
          ),
        ),
      ],
    );
  }
}

class _EngageSection extends StatelessWidget {
  const _EngageSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Engage',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _EngageCard(
                icon: Icons.report_problem,
                title: 'Report Issue',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Report feature coming soon')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _EngageCard(
                icon: Icons.feedback,
                title: 'Send Feedback',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Feedback feature coming soon')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EngageCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _EngageCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 36, color: Colors.blue),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
