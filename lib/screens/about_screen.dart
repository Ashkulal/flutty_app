import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("About ShopNow", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_bag_rounded, size: 60, color: Colors.orange),
              ),
            ),
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "ShopNow Premium",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -1),
              ),
            ),
            const Center(
              child: Text(
                "Est. 2026",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Our Story",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Text(
              "Experience the future of retail. ShopNow is the ultimate marketplace designed for the modern shopper, offering a luxury retail experience with high-performance Flutter technology and zero-fee UPI transactions. We believe that shopping should be fast, secure, and above all, beautiful.",
              style: TextStyle(color: Colors.grey[700], height: 1.6, fontSize: 15),
            ),
            const SizedBox(height: 30),
            const Text(
              "Why Choose Us?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildFeatureRow(Icons.bolt, "Instant Delivery Integration"),
            _buildFeatureRow(Icons.verified_user, "Secure UPI Transactions"),
            _buildFeatureRow(Icons.card_giftcard, "Exclusive Reward System"),
            _buildFeatureRow(Icons.support_agent, "24/7 Live WhatsApp Support"),
            const SizedBox(height: 50),
            const Center(
              child: Text(
                "Version 1.2.0 (Ultimate Build)",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                "© 2026 ShopNow Global. All rights reserved.",
                style: TextStyle(color: Colors.grey[400], fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 15),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        ],
      ),
    );
  }
}
