import 'package:flutter/material.dart';
import 'admin_dashboard.dart'; // Import your AdminDashboard
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFF4DE165),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            const SizedBox(height: 20),
            _buildMenuItem(Icons.inbox, 'Inbox', () {
              // Handle Inbox action
              print('Inbox tapped');
            }),
            _buildMenuItem(Icons.attach_money, 'Rent Item', () {
              // Handle Rent Item action
              print('Rent Item tapped');
            }),
            _buildMenuItem(Icons.help, 'Help and Support', () {
              // Handle Help and Support action
              print('Help and Support tapped');
            }),
            _buildMenuItem(Icons.settings, 'Settings', () {
              // Handle Settings action
              print('Settings tapped');
            }),
            _buildMenuItem(Icons.logout, 'Log Out', () => _logout(context)), // Log Out action
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://example.com/user.jpg'), // Replace with actual user image
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Sudai Alhad', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('sudai.alhad@one.uz.edu.ph'),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      currentIndex: 1, // Set to 1 since we're on the Settings screen
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()), // Navigate to Home
          );
        }
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut(); // Log out from Supabase
    Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen
  }
} 