import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  Future<void> _launchUPI(BuildContext context) async {
    const upiUrl = 'upi://pay?pa=akashkulal866087-1@okicici&pn=Akash&am=1.00&cu=INR&tn=PaymentForOrder';
    final Uri uri = Uri.parse(upiUrl);

    try {
      // Try to launch directly first (more reliable for UPI)
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Could not open UPI apps. If you are on an Emulator, please test on a Real Device."),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      debugPrint("UPI Launch Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please install GPay or PhonePe to use this feature."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Zero-Fee Payment", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            _buildFreeBadge(),
            const SizedBox(height: 30),
            const Text(
              "Pay via UPI QR Code",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Fast, Secure & 100% Free Transactions",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            
            // Premium QR Code Container
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.withOpacity(0.3), width: 2),
                    ),
                    child: const Icon(Icons.qr_code_2_rounded, size: 200, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "UPI ID: akashkulal866087-1@okicici",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.orange),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            const Text(
              "OR",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            
            _buildUPIAppButton(context, "Google Pay", Colors.blue, Icons.account_balance_wallet),
            const SizedBox(height: 15),
            _buildUPIAppButton(context, "PhonePe / Others", Colors.purple, Icons.send_to_mobile),
            
            const SizedBox(height: 30),
            Text(
              "Secure payment powered by NPCI / UPI",
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFreeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_outlined, color: Colors.green, size: 16),
          SizedBox(width: 8),
          Text(
            "ZERO TRANSACTION FEES",
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildUPIAppButton(BuildContext context, String name, Color color, IconData icon) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => _launchUPI(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: color.withOpacity(0.5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 15),
            Text(
              "PAY VIA ${name.toUpperCase()}",
              style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
