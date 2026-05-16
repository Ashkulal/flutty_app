import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class WishlistProvider with ChangeNotifier {
  List<Product> _items = [];

  WishlistProvider() {
    _loadFromPrefs();
  }

  List<Product> get items => [..._items];

  bool isFavorite(String productId) {
    return _items.any((p) => p.id == productId);
  }

  // --- Persistence Logic ---

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(_items.map((p) => p.toJson()).toList());
    await prefs.setString('wishlist_data', data);
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString('wishlist_data');
      if (data != null) {
        final List<dynamic> decoded = json.decode(data);
        _items = decoded.map((itemData) => Product.fromJson(itemData)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading wishlist: $e");
    }
  }

  // --- Actions ---

  void toggleFavorite(Product product) {
    final index = _items.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _items.removeAt(index);
    } else {
      _items.add(product);
    }
    _saveToPrefs();
    notifyListeners();
  }

  void clearWishlist() {
    _items.clear();
    _saveToPrefs();
    notifyListeners();
  }
}
