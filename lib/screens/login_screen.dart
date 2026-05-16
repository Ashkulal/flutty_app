import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/ecommerce_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  bool _isLoading = false;

  Future<void> _authenticate() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill in all fields.")));
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isSignUp) {
        final response = await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        
        // Create Profile record
        if (response.user != null) {
          await Supabase.instance.client.from('profiles').insert({
            'id': response.user!.id,
            'full_name': _emailController.text.split('@')[0], // Default name
          });
        }

        // Log Signup
        await EcommerceService().logActivity("Sign Up Attempt", _emailController.text.trim());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account created! Please check your email to confirm.")),
          );
        }
      } else {
        await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        // Log Login
        await EcommerceService().logActivity("User Login", _emailController.text.trim());
      }
    } catch (e) {
      if (mounted) {
        String msg = e.toString();
        if (msg.contains("Email not confirmed")) {
          msg = "Please confirm your email address before logging in.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.shopping_bag_rounded, size: 60, color: Colors.orange),
            ),
            const SizedBox(height: 30),
            Text(
              _isSignUp ? "Create Account" : "Welcome Back",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              _isSignUp ? "Sign up to start shopping" : "Login to your account",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email Address",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: "Password",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _authenticate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(_isSignUp ? "SIGN UP" : "LOGIN", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(
                _isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up",
                style: const TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
