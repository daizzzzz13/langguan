import 'package:flutter/material.dart';
import 'profile_screen.dart';  // Only import ProfileScreen from here
import 'exchange_screen.dart';  // Make sure this import is present
import 'store_screen.dart';
import 'add_item_screen.dart';
import 'cart_screen.dart';
import 'sell_screen.dart';
import 'tutoring_screen.dart';
import 'rent_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0; // Track the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding screen based on the selected index
    switch (index) {
      case 0:
        // Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const UserDashboard()),
        );
        break;
      case 1:
        // Store
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StoreScreen()),
        );
        break;
      case 2:
        // Add Item
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddItemScreen()),
        );
        break;
      case 3:
        // Cart
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartScreen()),
        );
        break;
      case 4:
        // Profile
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top App Bar with Logo and Title
          _buildAppBar(),

          // Category Buttons
          _buildCategorySection(context),

          // Search Bar
          _buildSearchBar(),

          // Popular Section
          _buildPopularSection(),

          // Top Rated Users Section
          _buildTopRatedUsersSection(),

          const Spacer(),

          // Bottom Navigation Bar
          _buildBottomNavigationBar(),
        ],
      ),
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
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Pro',
              style: TextStyle(color: Colors.white),
            ),
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
          _buildCategoryButton('Rent'),
          _buildCategoryButton('Exchange'),
          _buildCategoryButton('Sell'),
          _buildCategoryButton('Tutoring'),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the corresponding screen using pushReplacement
        switch (text) {
          case 'Rent':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RentScreen()),
            );
            break;
          case 'Exchange':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ExchangeScreen()),
            );
            break;
          case 'Sell':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SellScreen()),
            );
            break;
          case 'Tutoring':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TutoringScreen()),
            );
            break;
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: text == 'Rent' ? Colors.blue[200] : 
                        text == 'Exchange' ? Colors.blue[200] : 
                        text == 'Sell' ? Colors.blue[200] : 
                        Colors.blue[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildPopularSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Use a GridView for better layout
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildPopularItem('Sci-Cal', '₱10 per Hour', 'assets/images/calculator.jpg'),
              _buildPopularItem('Lab Gown', '₱20 per Hour', 'assets/images/lab_gown.jpg'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularItem(String title, String price, String imagePath) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: Image.asset(imagePath, height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Item for Rent: $title', style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(price, style: const TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Widget _buildTopRatedUsersSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Rated Users',
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildTopRatedUser('Sudaiz Alhad', 4.9, 'assets/images/profile.jpg'),
        ],
      ),
    );
  }

  Widget _buildTopRatedUser(String name, double rating, String imagePath) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.yellow),
          Text('$rating'),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Store',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RentScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const StoreScreen()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AddItemScreen()),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const CartScreen()),
            );
            break;
          case 4:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
        }
      },
    );
  }
}
