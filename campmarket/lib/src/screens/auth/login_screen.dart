import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      print('Attempting login with email: $email');

      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.session != null) {
        print('Login successful!');

        // Fetch the user's role from the profiles table
        final userId = response.user!.id;
        final profileResponse = await Supabase.instance.client
            .from('profiles')
            .select('role')
            .eq('id', userId)
            .maybeSingle(); // Fetch a single row if it exists

        if (profileResponse != null) {
          final role = profileResponse['role'] as String?;

          // Navigate based on the role
          switch (role) {
            case 'admin':
              Navigator.pushNamed(context, '/admin_dashboard');
              break;
            case 'user':
              Navigator.pushNamed(context, '/user_dashboard');
              break;
            default:
              _showSnackBar('Unknown role: $role');
          }
        } else {
          _showSnackBar('Profile not found for this user');
        }
      } else {
        _showSnackBar('Invalid email or password');
      }
    } catch (error) {
      print('Login error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
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
        child: Container(
          // Add semi-transparent overlay
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 50),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    width: 150,
                  ),
                  SizedBox(height: 40),
                  Text(
                    'LOGIN',
                    style: GoogleFonts.irishGrover(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 40),
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
                  CustomButton(
                    text: 'Login',
                    onPressed: _login,
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Create new account?',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          print('Forgot Password pressed');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  CustomButton2(
                    text: 'Google',
                    onPressed: _login,
                    icon: Image.asset(
                      'assets/images/google_icon.png',
                      height: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}