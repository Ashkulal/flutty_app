import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'id': 'ORD-9921', 'date': 'Today', 'total': 349.99, 'status': 'Shipping', 'items': 'Sony Elite Headphones'},
      {'id': 'ORD-8812', 'date': 'Oct 12, 2023', 'total': 180.00, 'status': 'Delivered', 'items': 'Nike Air Jordan 1'},
      {'id': 'ORD-7723', 'date': 'Sep 05, 2023', 'total': 45.00, 'status': 'Delivered', 'items': 'Matte Lipstick Kit'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text("Your Orders", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Order #${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: order['status'] == 'Delivered' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        order['status'] as String,
                        style: TextStyle(color: order['status'] == 'Delivered' ? Colors.green : Colors.orange, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(order['items'] as String, style: const TextStyle(fontSize: 15)),
                const SizedBox(height: 10),
                Text(order['date'] as String, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const Divider(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total: \$${order['total']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton(onPressed: () {}, child: const Text("View Details", style: TextStyle(color: Colors.orange))),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
