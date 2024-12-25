import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditNameScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final VoidCallback onUpdate;

  const EditNameScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditNameScreenState createState() => _EditNameScreenState();
}

class _EditNameScreenState extends State<EditNameScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
  }

  /// Update user name in Supabase
  Future<void> _updateUserName() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user != null) {
        final response = await Supabase.instance.client.from('profiles').update({
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
        }).eq('id', user.id);

        if (response.error == null) {
          print('Name updated successfully in Supabase!');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Name updated successfully!')),
          );
          widget.onUpdate(); // Refresh the profile screen
          Navigator.pop(context); // Close the edit screen
        } else {
          print('Error updating name: ${response.error!.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update name: ${response.error!.message}')),
          );
        }
      }
    } catch (e) {
      print('Error updating user name: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating name: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Name'),
        backgroundColor: const Color(0xFF4DE165),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _updateUserName,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4DE165)),
            ),
          ],
        ),
      ),
    );
  }
}  