import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

/// Splash Screen
/// Checks authentication status and navigates accordingly
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      print('Splash: Starting Auth Check...');
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.initialize();
      print(
        'Splash: Auth Provider Initialized. User: ${authProvider.currentUser?.email}',
      );

      // Wait for 1 second for smooth transition
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      if (authProvider.isAuthenticated) {
        print('Splash: Going Home');
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        print('Splash: Going Login');
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e, stack) {
      print('Splash: Error detected - $e');
      print(stack);
      // Fallback to login on error
      if (mounted) Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3F51B5), Color(0xFF303F9F)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.search,
                  size: 60,
                  color: Color(0xFF3F51B5),
                ),
              ),
              const SizedBox(height: 30),
              // App Title
              const Text(
                'Campus Lost & Found',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Find what matters',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const SizedBox(height: 50),
              // Loading Indicator
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
