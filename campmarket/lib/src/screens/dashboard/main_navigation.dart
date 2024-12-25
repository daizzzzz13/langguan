import 'package:flutter/material.dart';
import 'user_dashboard.dart'; // Import the UserDashboard
import 'store_screen.dart';   // Import the StoreScreen
import 'add_item_screen.dart'; // Import the AddItemScreen
import 'cart_screen.dart';    // Import the CartScreen
import 'profile_screen.dart'; // Import the ProfileScreen

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // Track the selected index

  // List of screens to navigate to
  final List<Widget> _screens = [
    UserDashboard(), // Home
    StoreScreen(),   // Store
    AddItemScreen(), // Add Item
    CartScreen(),    // Cart
    ProfileScreen(), // Profile
  ];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) { // Only update if the index is different
      setState(() {
        _selectedIndex = index; // Update the selected index
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _screens[_selectedIndex], // Display the selected screen
            ),
            BottomNavigationBar(
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
                  icon: Icon(Icons.add_circle_outline), // Add icon
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
              onTap: _onItemTapped, // Handle tap to change screen
            ),
          ],
        ),
      ),
    );
  }
}
