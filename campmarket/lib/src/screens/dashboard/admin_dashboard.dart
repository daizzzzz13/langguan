import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'rent_posts_screen.dart';
import 'sell_posts_screen.dart';
import 'exchange_posts_screen.dart';
import 'tutorials_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            _buildPostStats(context),
            const SizedBox(height: 16),
            _buildPopularItems(),
            const SizedBox(height: 16),
            _buildTopRatedUsers(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Campus Marketing'),
      backgroundColor: const Color(0xFF4DE165),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Handle notification action
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPostStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatButton('Rent Posts', '2 posts', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RentPostsScreen()),
          );
        }),
        _buildStatButton('Sell Posts', '5 posts', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SellPostsScreen()),
          );
        }),
        _buildStatButton('Exchange Posts', '1 post', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExchangePostsScreen()),
          );
        }),
        _buildStatButton('Tutorials', '10 posts', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TutorialsScreen()),
          );
        }),
      ],
    );
  }

  Widget _buildStatButton(String title, String count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF4DE165),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(count, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Popular', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildPopularItem('assets/images/calculator.jpg', 'Scientific Calculator', '₱10 per Hour'),
        _buildPopularItem('assets/images/lab_gown.jpg', 'Lab Gown', '₱20 per Hour'),
      ],
    );
  }

  Widget _buildPopularItem(String imageUrl, String itemName, String price) {
    return Row(
      children: [
        Image.asset(imageUrl, width: 50, height: 50),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item for Rent: $itemName'),
            Text(price, style: const TextStyle(color: Colors.orange)),
          ],
        ),
      ],
    );
  }

  Widget _buildTopRatedUsers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Top Rated Users', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildTopRatedUser('assets/images/profile.jpg', 'Sudai Alhad', '4.9'),
      ],
    );
  }

  Widget _buildTopRatedUser(String imageUrl, String userName, String rating) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(imageUrl),
        ),
        const SizedBox(width: 8),
        Text('$userName ⭐ $rating'),
      ],
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
      currentIndex: 0,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        }
      },
    );
  }
}