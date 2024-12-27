import 'package:flutter/material.dart';

class ExchangePostsScreen extends StatelessWidget {
  const ExchangePostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> posts = [
      {
        'item_name': 'Scientific Calculator',
        'image_path': 'assets/images/calculator.jpg',
        'description': '20 pesos per hour',
        'condition': 'Used',
        'price': '20',
        'owner_name': 'Sudaiz Alhad',
        'owner_rating': 4.9,
      },
      {
        'item_name': 'Lab Gown',
        'image_path': 'assets/images/lab_gown.jpg',
        'description': '30 pesos per day',
        'condition': 'New',
        'price': '30',
        'owner_name': 'Jalman Tadeo',
        'owner_rating': 4.7,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4DE165),
        title: const Text('Rent Posts'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return GestureDetector(
              onTap: () {
                _showItemDetails(context, post);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: Image.asset(
                    post['image_path'],
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    post['item_name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    '₱${post['price']} per ${post['description'].split(' ').last}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context, Map<String, dynamic> post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close Icon
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                // Item Image
                Image.asset(
                  post['image_path'],
                  height: 150,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 16),
                // Details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Product Name: ${post['item_name']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Product Description: ${post['description']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Condition: ${post['condition']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price: ₱${post['price']}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Approve and Reject Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Item Approved')),
                        );
                      },
                      child: const Text('Approve'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Item Rejected')),
                        );
                      },
                      child: const Text('Reject'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Owner Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: const AssetImage(
                        'assets/images/profile_placeholder.png', // Use a placeholder profile image
                      ),
                      radius: 24,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['owner_name'],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.orange, size: 16),
                            Text('${post['owner_rating']}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
