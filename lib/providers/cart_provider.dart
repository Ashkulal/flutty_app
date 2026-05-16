import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ecommerce_service.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};
  double _discountPercentage = 0.0;

  CartProvider() {
    _loadFromPrefs();
  }

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  int get totalItemsCount {
    int total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity;
    });
    return total;
  }

  double get subtotalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.product.price * cartItem.quantity;
    });
    return total;
  }

  double get discountAmount => subtotalAmount * _discountPercentage;

  double get totalAmount => subtotalAmount - discountAmount;

  // --- Persistence Logic ---
  
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String data = json.encode(
      _items.map((key, item) => MapEntry(key, item.toJson())),
    );
    await prefs.setString('cart_data', data);
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? data = prefs.getString('cart_data');
      if (data != null) {
        final Map<String, dynamic> decoded = json.decode(data);
        _items = decoded.map(
          (key, itemData) => MapEntry(key, CartItem.fromJson(itemData)),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading cart: $e");
    }
  }

  // --- Actions ---

  void applyDiscount(String code) {
    if (code.toUpperCase() == 'SAVE20') {
      _discountPercentage = 0.20;
    } else if (code.toUpperCase() == 'GIFT50') {
      _discountPercentage = 0.50;
    } else {
      _discountPercentage = 0.0;
    }
    notifyListeners();
  }

  void addItem(Product product, {int quantity = 1}) {
    // Log Activity for Admin
    EcommerceService().logActivity("Add to Cart", "${product.name} (x$quantity)");

    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + quantity,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product, quantity: quantity),
      );
    }
    _saveToPrefs();
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (_items.containsKey(productId)) {
      if (quantity <= 0) {
        _items.remove(productId);
      } else {
        _items.update(
          productId,
          (existingItem) => CartItem(
            product: existingItem.product,
            quantity: quantity,
          ),
        );
      }
      _saveToPrefs();
      notifyListeners();
    }
  }

  void removeItem(String productId) {
    _items.remove(productId);
    _saveToPrefs();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _discountPercentage = 0.0;
    _saveToPrefs();
    notifyListeners();
  }
}
