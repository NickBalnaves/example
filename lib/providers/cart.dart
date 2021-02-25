import 'package:flutter/material.dart';

/// A [ChangeNotifier] containing shopping cart data
class CartNotifier with ChangeNotifier {
  /// Shopping cart quanities
  /// Mapping: {Brand: {Price: Quantity}}
  /// dynamic as sometimes the api contains either a integer or string value
  Map<String, Map<dynamic, int>> quantities = {};

  /// Adding 1 item to the shopping cart
  void addToCart(String brand, dynamic price) {
    if (!quantities.containsKey(brand)) {
      quantities[brand] = {};
    }
    if (quantities[brand].containsKey(price)) {
      quantities[brand][price]++;
    } else {
      quantities[brand][price] = 1;
    }
    notifyListeners();
  }

  /// Removing 1 item to the shopping cart
  void removeFromCart(String brand, dynamic price) {
    if (quantities[brand][price] == 1) {
      quantities[brand].remove(price);
    } else {
      quantities[brand][price]--;
    }
    if (quantities[brand].isEmpty) {
      quantities.remove(brand);
    }
    notifyListeners();
  }

  /// Adding items to the shopping cart for a brand
  void addItemsToCart(String brand, Map<dynamic, int> items) {
    if (!quantities.containsKey(brand)) {
      quantities[brand] = {};
    }
    quantities[brand] = items;
    notifyListeners();
  }

  /// Removes cart items
  void checkoutCart() {
    quantities = {};
    notifyListeners();
  }
}
