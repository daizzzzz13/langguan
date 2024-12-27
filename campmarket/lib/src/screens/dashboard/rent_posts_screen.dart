import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RentPostsScreen extends StatefulWidget {
  const RentPostsScreen({Key? key}) : super(key: key);

  @override
  _RentPostsScreenState createState() => _RentPostsScreenState();
}

class _RentPostsScreenState extends State<RentPostsScreen> {
  List<dynamic> _items = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPendingItems();
  }

  Future<void> _fetchPendingItems() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await Supabase.instance.client
          .from('items')
          .select()
          .eq('category', 'Rent')
          .eq('status', 'Pending');

      print('Supabase Response: $response'); // Debugging response

      if (response != null && response is List<dynamic>) {
        setState(() {
          _items = response;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No items found.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching data: $e';
      });
    }
  }

  Future<void> _updateItemStatus(String itemId, String status) async {
    try {
      final response = await Supabase.instance.client
          .from('items')
          .update({'status': status})
          .eq('id', itemId);

      print('Update Response: $response'); // Debugging response

      if (response == null || response.error != null) {
        throw Exception('Failed to update status: ${response.error?.message}');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item $status successfully!')),
      );

      _fetchPendingItems(); // Refresh the list
    } catch (e) {
      print('Error: $e'); // Debugging error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rent Posts'),
        backgroundColor: const Color(0xFF4DE165),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        leading: item['image_url'] != null &&
                                item['image_url'].isNotEmpty
                            ? Image.network(
                                item['image_url'],
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported);
                                },
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text(
                          item['name'] ?? 'Unknown Item',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '₱${item['price']}',
                          style: const TextStyle(color: Colors.green),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _updateItemStatus(item['id'], 'Approved'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _updateItemStatus(item['id'], 'Rejected'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
