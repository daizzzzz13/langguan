import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class ProfileEditScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String? profilePictureUrl;
  final VoidCallback onUpdate;

  const ProfileEditScreen({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.profilePictureUrl,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  XFile? _selectedImage;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.firstName);
    _lastNameController = TextEditingController(text: widget.lastName);
  }

  /// Pick an image
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  /// Upload profile picture to Supabase
  Future<String?> _uploadProfilePicture(XFile file) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception('User is not authenticated.');
      }

      final fileName = 'profile_${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Convert the file to bytes
      final fileBytes = await file.readAsBytes();
      final filePath = 'profile_pictures/$fileName';

      // Upload the file
      final response = await Supabase.instance.client.storage
          .from('profile_pictures')
          .uploadBinary(filePath, fileBytes);

      if (response.isEmpty) {
        throw Exception('Error uploading profile picture: Empty response.');
      }

      // Get the public URL
      final publicUrl = Supabase.instance.client.storage
          .from('profile_pictures')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print('Error uploading profile picture: $e');
      return null;
    }
  }

  /// Update user profile in Supabase
  Future<void> _updateUserProfile() async {
    setState(() {
      _isSaving = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        throw Exception('User is not authenticated.');
      }

      String? profilePictureUrl;

      // Upload image if selected
      if (_selectedImage != null) {
        profilePictureUrl = await _uploadProfilePicture(_selectedImage!);
      }

      // Update the profile in the database
      await Supabase.instance.client.from('profiles').update({
        'first_name': _firstNameController.text.trim(),
        'last_name': _lastNameController.text.trim(),
        if (profilePictureUrl != null) 'profile_picture_url': profilePictureUrl,
      }).eq('id', user.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      widget.onUpdate(); // Refresh the profile screen
      Navigator.pop(context); // Close the edit screen
    } catch (e) {
      print('Error updating user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFF4DE165),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.purple.shade200,
                backgroundImage: _selectedImage != null
                    ? FileImage(File(_selectedImage!.path))
                    : widget.profilePictureUrl != null && widget.profilePictureUrl!.isNotEmpty
                        ? NetworkImage(widget.profilePictureUrl!)
                        : null,
                child: _selectedImage == null && (widget.profilePictureUrl == null || widget.profilePictureUrl!.isEmpty)
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
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
              onPressed: _isSaving ? null : _updateUserProfile,
              icon: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4DE165)),
            ),
          ],
        ),
      ),
    );
  }
}
