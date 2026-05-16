import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class EcommerceService {
  final _supabase = Supabase.instance.client;
  final String tableName = 'products';

  Future<List<Product>> getProducts() async {
    try {
      // Add a timeout to prevent hanging
      final response = await _supabase
          .from(tableName)
          .select()
          .order('created_at', ascending: false)
          .timeout(const Duration(seconds: 5));
      
      if (response == null) {
        debugPrint('EcommerceService: Response is null, using mock data.');
        return _getMockProducts();
      }

      final List data = response as List;
      final products = data.map((item) => Product.fromJson(item)).toList();
          
      if (products.isEmpty) {
        debugPrint('EcommerceService: Table is empty, using mock data.');
        return _getMockProducts();
      }
      
      return products;
    } catch (e) {
      debugPrint('EcommerceService Error: $e');
      // If any error occurs (connection, RLS, table missing), always return mock data
      return _getMockProducts();
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    if (query.isEmpty) return getProducts();
    try {
      final response = await _supabase
          .from(tableName)
          .select()
          .ilike('name', '%$query%');
      
      final List data = response as List;
      return data.map((item) => Product.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Search Error: $e');
      // Fallback search in mock data
      return _getMockProducts().where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  Future<List<String>> getCategories() async {
    return ['All', 'Electronics', 'Fashion', 'Home', 'Books', 'Gaming', 'Toys', 'Beauty', 'Outdoor', 'Fitness'];
  }

  List<Product> _getMockProducts() {
    return [
      Product(
        id: '1',
        name: 'Sony Elite Headphones',
        description: 'Industry-leading noise cancellation.',
        price: 349.99,
        imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=800',
        category: 'Electronics',
        rating: 4.9,
        stock: 50,
      ),
      Product(
        id: '2',
        name: 'MacBook Air M2',
        description: 'Ultra-thin, powerful, and portable.',
        price: 1199.00,
        imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800',
        category: 'Electronics',
        rating: 4.8,
        stock: 15,
      ),
      Product(
        id: '3',
        name: 'Nike Air Jordan 1',
        description: 'The iconic classic that started it all.',
        price: 180.00,
        imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
        category: 'Fashion',
        rating: 4.7,
        stock: 30,
      ),
      Product(
        id: '4',
        name: 'Espresso Barista Pro',
        description: 'Professional grade coffee at home.',
        price: 899.00,
        imageUrl: 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=800',
        category: 'Home',
        rating: 4.8,
        stock: 8,
      ),
      Product(
        id: '5',
        name: 'Gaming PC Master',
        description: 'RTX 4090 Powered ultimate machine.',
        price: 3999.00,
        imageUrl: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=800',
        category: 'Gaming',
        rating: 4.9,
        stock: 10,
      ),
    ];
  }
}
