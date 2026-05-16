import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'orders_screen.dart';
import 'wishlist_screen.dart';
import 'payment_screen.dart';
import 'gift_card_screen.dart';
import 'about_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    final user = Supabase.instance.client.auth.currentUser;
    // Log Activity
    await EcommerceService().logActivity("User Sign Out", user?.email ?? "Unknown");
    
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final email = user?.email ?? 'User';
    final name = email.split('@')[0].toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, name),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildQuickActions(context),
                _buildAccountSection(context),
                _buildSettingsSection(context),
                const SizedBox(height: 30),
                _buildLogoutButton(context),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String name) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Colors.orange,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        title: Text(
          "Hello, ${name.toUpperCase()}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange.shade700, Colors.orange.shade400],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.white),
          onPressed: () {},
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 2.2,
        children: [
          _buildActionCard(context, Icons.inventory_2_outlined, "Your Orders", const OrdersScreen()),
          _buildActionCard(context, Icons.favorite_border_rounded, "Your Wish List", const WishlistScreen()),
          _buildActionCard(context, Icons.payment_rounded, "Your Payments", const PaymentScreen()),
          _buildActionCard(context, Icons.location_on_outlined, "Your Addresses", null),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title, Widget? target) {
    return GestureDetector(
      onTap: () {
        if (target != null) {
          _navigateTo(context, target);
        } else {
          _showComingSoon(context, title);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.orange, size: 20),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSection(
      "Account Settings",
      [
        _buildListTile(context, Icons.person_outline_rounded, "Login & Security", null),
        _buildListTile(context, Icons.shopping_cart_outlined, "Prime Membership", null),
        _buildListTile(context, Icons.card_giftcard_rounded, "Manage Gift Cards", const GiftCardScreen()),
      ],
    );
  }

  Future<void> _launchWhatsApp(BuildContext context, {bool isGroup = false}) async {
    final url = isGroup 
      ? "https://chat.whatsapp.com/ED49CaaIU7CDdFYK5rpd1J"
      : "whatsapp://send?phone=918660874196&text=Hello Akash! I need help with ShopNow.";
    final uri = Uri.parse(url);

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not open WhatsApp.")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  Widget _buildSettingsSection(BuildContext context) {
    return _buildSection(
      "Customer Service",
      [
        ListTile(
          leading: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.green),
          title: const Text("Chat with Founder (WhatsApp)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () => _launchWhatsApp(context, isGroup: false),
        ),
        ListTile(
          leading: const Icon(Icons.groups_outlined, color: Colors.blue),
          title: const Text("Join Community Group", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: () => _launchWhatsApp(context, isGroup: true),
        ),
        _buildListTile(context, Icons.help_outline_rounded, "Contact Us", null),
        _buildListTile(context, Icons.info_outline_rounded, "About ShopNow", const AboutScreen()),
        _buildListTile(context, Icons.description_outlined, "Legal & Privacy", null),
      ],
    );
  }

  void _showInfoMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Opening $title..."),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.orange,
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, Widget? target) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      onTap: () {
        if (target != null) {
          _navigateTo(context, target);
        } else {
          _showInfoMessage(context, title);
        }
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 55,
        child: OutlinedButton(
          onPressed: () => _signOut(context),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          child: const Text("Sign Out", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
