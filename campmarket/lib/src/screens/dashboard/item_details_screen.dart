import 'package:flutter/material.dart';
import 'chat_screen.dart'; // Import the new ChatScreen

class ItemDetailsScreen extends StatefulWidget {
  final String title;
  final String imagePath;
  final String rentalRate;

  const ItemDetailsScreen({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.rentalRate,
  }) : super(key: key);

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  int quantity = 1; // Default quantity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: const Color(0xFF4DE165),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatScreen()), // Navigate to ChatScreen
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(widget.imagePath, height: 150), // Display item image
            ),
            const SizedBox(height: 20),
            Text(
              'Item for Rent: ${widget.title}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Rental Rate: ${widget.rentalRate}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            const Text(
              '₱25 pesos for each additional hour',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:', style: TextStyle(fontSize: 18)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (quantity > 1) quantity--; // Decrease quantity
                        });
                      },
                    ),
                    Text('₱${quantity * 20}', style: const TextStyle(fontSize: 18)), // Update total based on quantity
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          quantity++; // Increase quantity
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle rent action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Rent', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            const Text('Seller: Sudai Alhad ⭐ 4.5', style: TextStyle(fontSize: 16)),
            TextButton(
              onPressed: () {
                // Handle visit seller action
              },
              child: const Text('Visit', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
