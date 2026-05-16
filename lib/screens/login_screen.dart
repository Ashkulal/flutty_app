import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/ecommerce_service.dart';
import 'product_list_screen.dart';

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
        await Supabase.instance.client.auth.signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        
        await EcommerceService().logActivity("Sign Up Attempt", _emailController.text.trim());

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account created! Welcome to ShopNow."),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await EcommerceService().logActivity("User Login", _emailController.text.trim());
      }

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const ProductListScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        String msg = e.toString();
        if (msg.contains("Email not confirmed")) {
          msg = "Please confirm your email address before logging in.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: const Icon(Icons.shopping_bag_rounded, size: 50, color: Colors.orangeAccent),
              ),
              const SizedBox(height: 40),
              const Text(
                "SHOPNOW",
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
              Text(
                _isSignUp ? "Join the elite marketplace" : "Sign in to your premium account",
                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
              ),
              const SizedBox(height: 50),
              _buildTextField(_emailController, "Email Address", Icons.alternate_email_rounded),
              const SizedBox(height: 20),
              _buildTextField(_passwordController, "Password", Icons.lock_person_rounded, isPassword: true),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _authenticate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 0,
                  ),
                  child: _isLoading 
                    ? const SizedBox(width: 25, height: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_isSignUp ? "CREATE ACCOUNT" : "SIGN IN", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _isSignUp = !_isSignUp),
                  child: RichText(
                    text: TextSpan(
                      text: _isSignUp ? "Already a member? " : "New to ShopNow? ",
                      style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      children: [
                        TextSpan(
                          text: _isSignUp ? "Login" : "Sign Up",
                          style: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
          prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
