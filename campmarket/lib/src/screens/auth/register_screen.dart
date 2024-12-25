import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register() async {
    try {
      // First, check if passwords match
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
        return;
      }

      // Sign up with Supabase
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        emailRedirectTo: 'io.supabase.flutterquickstart://login-callback/',
        data: {
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
        },
      );

      if (response.user != null) {
        // Create profile in the profiles table
        await Supabase.instance.client.from('profiles').insert({
          'id': response.user!.id,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'email': _emailController.text.trim(),
          'role': 'user',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please check your email for confirmation link')),
        );
        
        // Navigate to login screen
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      print('Registration error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${error.toString()}')),
      );
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/campus_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                width: 150,
              ),
              SizedBox(height: 30),
              Text(
                'Register',
                style: GoogleFonts.irishGrover(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _firstNameController,
                      hintText: 'First Name',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _lastNameController,
                      hintText: 'Last Name',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomDropdownButton(
                      hintText: 'Gender',
                      items: ['Male', 'Female', 'Other'],
                      onChanged: (value) {
                        setState(() {
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CustomDateButton(
                      hintText: 'Select Birthdate',
                      onDateSelected: (selectedDate) {
                        setState(() {
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                hintText: 'Password',
                obscureText: true,
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                obscureText: true,
              ),
              SizedBox(height: 30),
              CustomButton(
                text: 'Register',
                onPressed: _register,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Already have an account?',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}