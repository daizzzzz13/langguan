import 'package:flutter/material.dart';
import 'admin_dashboard.dart'; // Admin Dashboard
import 'profile_edit_screen.dart'; // Profile Edit Screen
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _profilePictureUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  /// Fetch user information from Supabase
  Future<void> _fetchUserInfo() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('first_name, last_name, email, profile_picture_url')
            .eq('id', user.id)
            .single();

        if (response != null) {
          setState(() {
            _firstName = response['first_name'];
            _lastName = response['last_name'];
            _email = response['email'];
            _profilePictureUrl = response['profile_picture_url'];
          });
        }
      }
    } catch (e) {
      print('Error fetching user info: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Refresh the screen after profile update
  void _refreshUserInfo() {
    _fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserInfo(context),
                  const SizedBox(height: 20),
                  _buildMenuItem(Icons.inbox, 'Inbox', () {
                    print('Inbox tapped');
                  }),
                  _buildMenuItem(Icons.attach_money, 'Rent Item', () {
                    print('Rent Item tapped');
                  }),
                  _buildMenuItem(Icons.help, 'Help and Support', () {
                    print('Help and Support tapped');
                  }),
                  _buildMenuItem(Icons.settings, 'Settings', () {
                    print('Settings tapped');
                  }),
                  _buildMenuItem(Icons.logout, 'Log Out', () => _logout(context)),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF4DE165),
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.png'),
                  radius: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Campus Marketing',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Icon(Icons.notifications, color: Colors.white),
          ],
        ),
      ),
      toolbarHeight: 60,
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: _profilePictureUrl != null
                  ? NetworkImage(_profilePictureUrl!)
                  : const AssetImage('assets/images/default_user.png') as ImageProvider,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_firstName ?? ''} ${_lastName ?? ''}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(_email ?? 'No email available'),
              ],
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileEditScreen(
                  firstName: _firstName ?? '',
                  lastName: _lastName ?? '',
                  profilePictureUrl: _profilePictureUrl,
                  onUpdate: _refreshUserInfo, // Refresh info on profile update
                ),
              ),
            );
          },
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
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      currentIndex: 1,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
          );
        }
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
