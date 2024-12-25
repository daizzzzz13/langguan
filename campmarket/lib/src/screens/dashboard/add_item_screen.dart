import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'user_dashboard.dart';
import 'store_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'rent_screen.dart';
import 'exchange_screen.dart';
import 'sell_screen.dart';
import 'tutoring_screen.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Handle the selected image (e.g., display it or upload it)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top App Bar with Logo and Title
            _buildAppBar(),

            // Category Buttons
            _buildCategorySection(context),
            const SizedBox(height: 20), // Consistent spacing

            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 20), // Add spacing below the search bar

            // Add Photo Button
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '+ Add Photo',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Product Name Field
            _buildTextField('Product Name *', 'Enter Product Name', 1000),
            const SizedBox(height: 16),

            // Product Description Field
            _buildTextField('Product Description *', 'Enter Product Description', 3000),
            const SizedBox(height: 16),

            // Category Dropdown
            _buildDropdown('Category *', ['Rent', 'Sell', 'Exchange', 'Tutoring Video']),
            const SizedBox(height: 16),

            // Condition Dropdown
            _buildDropdown('Condition *', ['New', 'Used', 'Old', 'Damaged']),
            const SizedBox(height: 16),

            // Price Field
            _buildTextField('Price *', 'Enter Price', 100),
            const SizedBox(height: 16),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                // Handle item submission
              },
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
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
        backgroundColor: Colors.blue[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
        ),
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

  Widget _buildTextField(String label, String hint, int maxLength) {
    return TextField(
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    String? selectedValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (String? newValue) {
            selectedValue = newValue;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
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
      currentIndex: 2, // Set the index for the Add Item screen
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        // Handle navigation based on the selected index
        if (index != 2) {
          // Navigate to the selected screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) {
              switch (index) {
                case 0:
                  return const UserDashboard(); // Home
                case 1:
                  return const StoreScreen(); // Store
                case 3:
                  return const CartScreen(); // Cart
                case 4:
                  return const ProfileScreen(); // Profile
                default:
                  return const AddItemScreen(); // Stay on Add Item
              }
            }),
          );
        }
      },
    );
  }
}