import 'package:flutter/material.dart';
import 'screens/home_tab.dart';
import 'screens/states_tab.dart';
import 'screens/projects_tab.dart';
import 'screens/profile_tab.dart';
import 'package:logging/logging.dart';
// import 'my_app.dart'; // Your main app
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../database/civic_flutter_db.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // needed for async before runApp

  void printTables() async {
    final db = await AppDatabase.database;

    final users = await db.query('users');
    final projects = await db.query('projects');

    debugPrint('Users: $users');
    debugPrint('Projects: $projects');
  }
  printTables();
  // Configure global logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint(
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}');
  });

  // Print database path
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'civictrail.db');
  debugPrint('SQLite database path: $path');

  runApp(const MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'civictrail',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    _tabs = [
      const HomeTab(),
      const StatesTab(),
      const ProjectsTab(),
      ProfileTab(onLoginSuccess: switchToHome)
    ];
  }

  void switchToHome() {
    setState(() {
      _selectedIndex = 0;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'States',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_outlined),
            activeIcon: Icon(Icons.business),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
