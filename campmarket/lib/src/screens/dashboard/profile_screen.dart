import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_edit_screen.dart'; // Import the ProfileEditScreen
import 'user_dashboard.dart';
import 'cart_screen.dart';
import 'store_screen.dart';
import 'add_item_screen.dart';
import '../auth/login_screen.dart';
import 'exchange_screen.dart';
import 'sell_screen.dart';
import 'tutoring_screen.dart';
import 'rent_screen.dart';
import 'package:image_picker/image_picker.dart'; // Import the image_picker package

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _profilePictureUrl; // Add profile picture URL
  bool _isLoading = true;

  final ImagePicker _picker = ImagePicker(); // Create an instance of ImagePicker

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  /// Fetch user information from Supabase
  Future<void> _fetchUserInfo() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('first_name, last_name, email, profile_picture_url') // Include profile_picture_url
            .eq('id', user.id)
            .single();

        if (response != null) {
          setState(() {
            _firstName = response['first_name'];
            _lastName = response['last_name'];
            _email = response['email'];
            _profilePictureUrl = response['profile_picture_url']; // Fetch profile picture URL
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching user info: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Refresh profile information after editing
  void _refreshProfile() {
    setState(() {
      _isLoading = true;
    });
    _fetchUserInfo();
  }

  /// Logout logic
  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Navigator.pushReplacementNamed(context, '/login'); // Adjust your login route
    } catch (e) {
      print('Error logging out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 20),
            _buildCategorySection(context),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildProfileInfo(),
            const SizedBox(height: 20),
            _buildOptionsList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 10),
      color: const Color(0xFF4DE165),
      child: Row(
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
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.blue.shade200, borderRadius: BorderRadius.circular(15)),
            child: const Text('Pro', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.notifications, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryButton('Rent', context),
          _buildCategoryButton('Exchange', context),
          _buildCategoryButton('Sell', context),
          _buildCategoryButton('Tutoring', context),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the corresponding screen
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black)),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          suffixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.purple.shade200,
            backgroundImage: _profilePictureUrl != null
                ? NetworkImage(_profilePictureUrl!) // Show profile picture
                : null,
            child: _profilePictureUrl == null
                ? const Icon(Icons.person, size: 30, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_firstName ?? ''} ${_lastName ?? ''}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileEditScreen(
                              firstName: _firstName ?? '',
                              lastName: _lastName ?? '',
                              onUpdate: _refreshProfile,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Text(
                  _email ?? 'No email available',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const Text(
                  '⭐ 4.9',
                  style: TextStyle(fontSize: 16, color: Colors.orange),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildListTile(Icons.inbox, 'Inbox', () => _navigateTo('Inbox')),
          _buildListTile(Icons.shopping_cart, 'Rent Item', () => _navigateTo('Rent Item')),
          _buildListTile(Icons.swap_horiz, 'Exchange', () => _navigateTo('Exchange')),
          _buildListTile(Icons.label, 'Sell', () => _navigateTo('Sell')),
          _buildListTile(Icons.video_library, 'Tutoring Video', () => _navigateTo('Tutoring Video')),
          _buildListTile(Icons.help, 'Help and Support', () => _navigateTo('Help and Support')),
          _buildListTile(Icons.settings, 'Setting', () => _navigateTo('Setting')),
          _buildListTile(Icons.logout, 'Logout', _logout), // Added logout button
        ],
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title, VoidCallback onTap) {
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
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
        BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
      currentIndex: 4, // Set to Profile tab
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/user_dashboard');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/store');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/add_item');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/cart');
            break;
          case 4:
            // Already on Profile screen, do nothing
            break;
        }
      },
    );
  }

  void _navigateTo(String title) {
    print('Navigating to $title'); // Placeholder for navigation logic
  }
}
