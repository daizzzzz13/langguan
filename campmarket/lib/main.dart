import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'src/screens/dashboard/exchange_screen.dart';
import 'src/screens/dashboard/profile_screen.dart';
import 'src/screens/dashboard/user_dashboard.dart';
import 'src/screens/dashboard/store_screen.dart';
import 'src/screens/dashboard/cart_screen.dart';
import 'src/screens/auth/login_screen.dart';
import 'src/screens/auth/register_screen.dart';
import 'src/screens/dashboard/admin_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://ussawyzusbiomweppaix.supabase.co',  // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVzc2F3eXp1c2Jpb213ZXBwYWl4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ1NDE2MjksImV4cCI6MjA1MDExNzYyOX0.X1PKZNaZm0RQn-gRTGK9JU0Wiws4NXkzwqyq2gTjGqg',  // Replace with your Supabase anon key
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Marketing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/user_dashboard': (context) => const UserDashboard(),
        '/profile': (context) => const ProfileScreen(),
        '/exchange': (context) => const ExchangeScreen(),
        '/store': (context) => const StoreScreen(),
        '/cart': (context) => const CartScreen(),
        '/admin_dashboard': (context) => const AdminDashboard(),
      },
    );
  }
}
