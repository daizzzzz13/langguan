import 'package:flutter/material.dart';
import 'item_details_screen.dart'; // Import the new ItemDetailsScreen

class RentItemsScreen extends StatelessWidget {
  const RentItemsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Items'),
        backgroundColor: const Color(0xFF4DE165),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available for Rent',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildRentItem(
                    context,
                    'Scientific Calculator',
                    '₱50 per Day',
                    'assets/images/calculator.jpg',
                  ),
                  _buildRentItem(
                    context,
                    'Lab Gown',
                    '₱20 per Hour',
                    'assets/images/lab_gown.jpg',
                  ),
                  // Add more items as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRentItem(BuildContext context, String title, String price, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ItemDetailsScreen(
              title: title,
              imagePath: imagePath,
              rentalRate: price,
            ),
          ),
        );
      },
      child: Card(
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
            ],
          ),
        ),
      ),
    );
  }
} 