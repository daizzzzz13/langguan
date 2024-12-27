import 'package:flutter/material.dart';
import 'user_dashboard.dart'; // Import UserDashboard
import 'package:supabase_flutter/supabase_flutter.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({Key? key}) : super(key: key);

  @override
  _RentScreenState createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  List<dynamic> _items = [];
  List<dynamic> _filteredItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchApprovedItems();
  }

  Future<void> _fetchApprovedItems() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await Supabase.instance.client
          .from('items')
          .select()
          .eq('category', 'Rent')
          .eq('status', 'Approved');

      if (response != null && response is List<dynamic>) {
        setState(() {
          _items = response;
          _filteredItems = response; // Initialize filtered items
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No items found.')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching items: $e')),
      );
    }
  }

  void _filterItems(String query) {
    final filtered = _items.where((item) {
      final itemName = item['name']?.toLowerCase() ?? '';
      return itemName.contains(query.toLowerCase());
    }).toList();

    setState(() {
      _filteredItems = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Item'),
        backgroundColor: const Color(0xFF4DE165),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserDashboard()),
            );
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredItems.isEmpty
              ? const Center(
                  child: Text(
                    'No items available for rent.',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      TextField(
                        onChanged: _filterItems,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          suffixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Rent Items Section
                      const Text(
                        'Rent Items',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Grid View of Items
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.75, // Adjusted for larger images
                          ),
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Item Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: item['image_url'] != null &&
                                              item['image_url'].isNotEmpty
                                          ? Image.network(
                                              item['image_url'],
                                              height: 150, // Larger image
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error,
                                                  stackTrace) {
                                                return const Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                );
                                              },
                                            )
                                          : const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                            ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Item Details
                                    Text(
                                      item['name'] ?? 'Unknown Item',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₱${item['price']}',
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                                    const Spacer(),
                                    // Rent Now Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Handle Rent Now button click
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${item['name']} rented successfully!'),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text(
                                          'Rent Now',
                                          style:
                                              TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}