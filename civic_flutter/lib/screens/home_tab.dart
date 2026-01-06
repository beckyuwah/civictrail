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
    final projects =
        await ProjectDao.getHomeProjects(); // projects where show_on_home = 1
    if (!mounted) return;
    setState(() {
      homeProjects = projects;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          // Colors.grey.shade100,
          const Color.fromARGB(255, 198, 177, 229),
      appBar: AppBar(
        title: const Text('CivicTrail'),
        elevation: 0,
        backgroundColor:
            // Colors.grey.shade100,
            const Color.fromARGB(255, 157, 111, 225),
        actions: [
          if (Session.isLoggedIn)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Text(Session.currentUser!.username,
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

class _NewsCarousel extends StatefulWidget {
  const _NewsCarousel();

  @override
  State<_NewsCarousel> createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<_NewsCarousel> {
  final PageController _controller =
      PageController(viewportFraction: 0.9);

  int _currentPage = 0;
  final int _pageCount = 3;

  void _goToPage(int page) {
    _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: _pageCount,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
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
                                Colors.black.withOpacity(0.8),
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

              /// ◀ Left Chevron
              Positioned(
                left: 0,
                child: IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.chevron_left),
                  color: _currentPage == 0
                      ? Colors.grey
                      : Colors.white,
                  onPressed: _currentPage == 0
                      ? null
                      : () => _goToPage(_currentPage - 1),
                ),
              ),

              /// ▶ Right Chevron
              Positioned(
                right: 0,
                child: IconButton(
                  iconSize: 32,
                  icon: const Icon(Icons.chevron_right),
                  color: _currentPage == _pageCount - 1
                      ? Colors.grey
                      : Colors.white,
                  onPressed: _currentPage == _pageCount - 1
                      ? null
                      : () => _goToPage(_currentPage + 1),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 12) / 2;

            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: projects.map((project) {
                return SizedBox(
                  width: itemWidth, // 👈 forces 2 columns
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(project.description),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(project.state),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
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
