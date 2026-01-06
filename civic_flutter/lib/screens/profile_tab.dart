import 'package:flutter/material.dart';
import '../database/user_dao.dart';
import '../models/user.dart';
import '../services/session.dart';
import 'projects_tab.dart';

class ProfileTab extends StatefulWidget {
  final VoidCallback? onLoginSuccess;

  const ProfileTab({super.key, this.onLoginSuccess});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final _formKey = GlobalKey<FormState>();
  bool isLogin = true;

  String username = '';
  String email = '';
  String password = '';
  String location = '';

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (isLogin) {
      final user = await UserDao.login(email, password);
      if (user == null) {
        _snack('Invalid email or password');
        return;
      }

      Session.login(user);

      // Redirect to Home tab after login
      if (widget.onLoginSuccess != null) {
        widget.onLoginSuccess!();
      }

      setState(() {}); // Refresh ProfileTab to show user info
    } else {
      await UserDao.registerUser(
        User(
          username: username,
          email: email,
          password: password,
          location: location,
        ),
      );
      _snack('Registration successful');
      setState(() => isLogin = true); // Switch to login view after registration
    }
  }

  void logout() {
    Session.logout();
    setState(() {});
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      body: Session.isLoggedIn ? _profileView(context) : _authView(),
    );
  }

  //  AUTH VIEW
  Widget _authView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isLogin ? 'Welcome Back' : 'Create Account',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),
                  if (!isLogin)
                    _field('Username', Icons.person, (v) => username = v),
                  _field('Email', Icons.email, (v) => email = v),
                  if (!isLogin)
                    _field('Location', Icons.location_on, (v) => location = v),
                  _field('Password', Icons.lock, (v) => password = v,
                      obscure: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(isLogin ? 'Login' : 'Register'),
                  ),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin
                          ? "Don't have an account? Register"
                          : "Already have an account? Login",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //  PROFILE VIEW
  Widget _profileView(BuildContext context) {
    final user = Session.currentUser!;

    return SafeArea(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff667eea), Color(0xff764ba2)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50),
                ),
                const SizedBox(height: 10),
                Text(
                  user.username,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  user.email,
                  style: const TextStyle(color: Colors.white70),
                ),
                if (Session.isAdmin)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Chip(
                      label: Text('ADMIN'),
                      backgroundColor: Colors.orange,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 25),
          _infoTile(Icons.location_on, 'Location', user.location),

          // ADMIN CONTROLS
          if (Session.isAdmin)
            Card(
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: const Icon(Icons.work),
                title: const Text('Manage Projects'),
                subtitle: const Text('Add or delete projects'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProjectsTab(),
                    ),
                  );
                },
              ),
            ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: logout,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }

  Widget _field(
    String label,
    IconData icon,
    Function(String) onChanged, {
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        validator: (v) => v!.isEmpty ? '$label required' : null,
        onChanged: onChanged,
      ),
    );
  }
}
