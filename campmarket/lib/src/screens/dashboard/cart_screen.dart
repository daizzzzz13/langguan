import 'package:flutter/material.dart';// Ensure this import is present
import 'user_dashboard.dart'; // Import UserDashboard
import 'store_screen.dart';   // Import StoreScreen
import 'add_item_screen.dart'; // Import AddItemScreen
import 'profile_screen.dart'; // Import ProfileScreen
import 'exchange_screen.dart';
import 'rent_screen.dart';
import 'sell_screen.dart';
import 'tutoring_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // List to hold cart items
  List<Map<String, String>> cartItems = [
    {'title': 'Scientific Calculator', 'price': '₱10 per Hour', 'imagePath': 'assets/images/calculator.jpg'},
    // Removed 'Lab Gown' item
    // Add more items as needed
  ];

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index); // Remove item from the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Make the body scrollable
        child: Column(
          children: [
            // Custom Header
            _buildHeader(),

            const SizedBox(height: 20),

            // Category Buttons
            _buildCategorySection(context),
            const SizedBox(height: 20),

            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 20),

            // Cart Items Section
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Align to the left
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16.0), // Add some left padding
                  child: Text(
                    'Items in Your Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // List of cart items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Disable scrolling for the inner ListView
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(
                  cartItems[index]['title']!,
                  cartItems[index]['price']!,
                  cartItems[index]['imagePath']!,
                  index,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 10),
      color: const Color(0xFF4DE165), // Header background color
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

  Widget _buildCartItem(String title, String price, String imagePath, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(imagePath, height: 60, width: 60, fit: BoxFit.cover),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(price, style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () => _removeItem(index), // Call remove function
            ),
          ],
        ),
      ),
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
      currentIndex: 3, // Set the index for the Cart screen
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        // Handle navigation based on the selected index
        if (index != 3) {
          // Navigate to the selected screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              switch (index) {
                case 0:
                  return const UserDashboard(); // Home
                case 1:
                  return const StoreScreen(); // Store
                case 2:
                  return const AddItemScreen(); // Add Item
                case 4:
                  return const ProfileScreen(); // Profile
                default:
                  return const CartScreen(); // Stay on Cart
              }
            }),
          );
        }
      },
    );
  }
}
