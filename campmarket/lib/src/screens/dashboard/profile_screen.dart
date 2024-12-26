import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_dashboard.dart';
import 'cart_screen.dart';
import 'store_screen.dart';
import 'add_item_screen.dart';
import '../auth/login_screen.dart';
import 'exchange_screen.dart';
import 'sell_screen.dart';
import 'tutoring_screen.dart';
import 'rent_screen.dart';
import 'profile_edit_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  Future<void> _fetchUserInfo() async {
    try {
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

  void _refreshProfile() {
    _fetchUserInfo();
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      Navigator.pushReplacementNamed(context, '/login');
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

            // New Buttons Section
            _buildCategorySection(context),

            // Search Bar
            _buildSearchBar(),

            _buildProfileInfo(),
            const SizedBox(height: 20),
            _buildOptionsList(context),
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
          const Icon(Icons.notifications, color: Colors.white),
        ],
      ),
    );
  }

  // New Category Section for Buttons
  Widget _buildCategorySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCategoryButton(context, 'Rent', const RentScreen()),
          _buildCategoryButton(context, 'Exchange', const ExchangeScreen()),
          _buildCategoryButton(context, 'Sell', const SellScreen()),
          _buildCategoryButton(context, 'Tutoring', const TutoringScreen()),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String text, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search',
          suffixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
            radius: 50,
            backgroundColor: Colors.purple.shade200,
            backgroundImage: _profilePictureUrl != null && _profilePictureUrl!.isNotEmpty
                ? NetworkImage(_profilePictureUrl!) as ImageProvider
                : null,
            child: _profilePictureUrl == null || _profilePictureUrl!.isEmpty
                ? const Icon(Icons.person, size: 50, color: Colors.white)
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
                              profilePictureUrl: _profilePictureUrl ?? '',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildListTile(Icons.inbox, 'Inbox', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const UserDashboard()));
          }),
          _buildListTile(Icons.shopping_cart, 'Rent Item', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RentScreen()));
          }),
          _buildListTile(Icons.swap_horiz, 'Exchange', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ExchangeScreen()));
          }),
          _buildListTile(Icons.label, 'Sell', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SellScreen()));
          }),
          _buildListTile(Icons.video_library, 'Tutoring Video', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TutoringScreen()));
          }),
          _buildListTile(Icons.help, 'Help and Support', () {
            // Navigate to Help and Support screen
          }),
          _buildListTile(Icons.settings, 'Settings', () {
            // Navigate to Settings screen
          }),
          _buildListTile(Icons.logout, 'Logout', _logout),
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
      currentIndex: 4,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserDashboard()));
            break;
          case 1:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StoreScreen()));
            break;
          case 2:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddItemScreen()));
            break;
          case 3:
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            break;
          case 4:
            break; // Already on Profile screen
        }
      },
    );
  }
}
