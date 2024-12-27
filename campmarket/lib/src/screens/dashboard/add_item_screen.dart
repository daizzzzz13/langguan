import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({Key? key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedCategory;
  String? _selectedCondition;
  File? _imageFile; // For Mobile
  Uint8List? _webImage; // For Web
  String? _imageName;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Flutter Web: Use XFile and read as bytes
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List webImageBytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = webImageBytes;
          _imageName = pickedFile.name;
        });
      }
    } else {
      // Flutter Mobile: Use File
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          _imageName = pickedFile.path.split('/').last;
        });
      }
    }
  }

  Future<void> _submitItem() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedCondition == null ||
        (_imageFile == null && _webImage == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final supabase = Supabase.instance.client;

      // Check and upload image to Supabase Storage
      final imageName = const Uuid().v4(); // Generate a unique file name
      String? publicUrl;

      if (kIsWeb && _webImage != null) {
        // Flutter Web: Upload Uint8List
        final response = await supabase.storage
            .from('items') // Ensure this bucket exists in your Supabase project
            .uploadBinary('$imageName.jpg', _webImage!);

        if (response.isEmpty) {
          throw Exception('Failed to upload image. Please ensure the "items" bucket exists.');
        }
        publicUrl = supabase.storage.from('items').getPublicUrl('$imageName.jpg');
      } else if (_imageFile != null) {
        // Flutter Mobile: Upload File
        final response = await supabase.storage
            .from('items') // Ensure this bucket exists in your Supabase project
            .upload('$imageName.jpg', _imageFile!);

        if (response.isEmpty) {
          throw Exception('Failed to upload image. Please ensure the "items" bucket exists.');
        }
        publicUrl = supabase.storage.from('items').getPublicUrl('$imageName.jpg');
      }

      // Insert item into Supabase database
      final user = supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final response = await supabase.from('items').insert({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'category': _selectedCategory,
        'condition': _selectedCondition,
        'price': double.parse(_priceController.text),
        'image_url': publicUrl,
        'status': 'Pending',
        'user_id': user.id,
      });

      if (response.error != null) {
        throw Exception(response.error!.message);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item submitted successfully')));

      // Clear fields
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedCondition = null;
        _imageFile = null;
        _webImage = null;
        _imageName = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        backgroundColor: const Color(0xFF4DE165),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _webImage != null
                      ? Image.memory(_webImage!, fit: BoxFit.cover)
                      : _imageFile != null
                          ? Image.file(_imageFile!, fit: BoxFit.cover)
                          : const Center(child: Text('+ Add Photo')),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Product Description *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(),
                ),
                items: ['Rent', 'Sell', 'Exchange']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCondition,
                decoration: const InputDecoration(
                  labelText: 'Condition *',
                  border: OutlineInputBorder(),
                ),
                items: ['New', 'Used']
                    .map((condition) => DropdownMenuItem(
                          value: condition,
                          child: Text(condition),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCondition = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitItem,
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
