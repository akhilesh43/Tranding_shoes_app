import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:flutter_application_14/data/dummy_data.dart' show dummyProducts;
import 'package:flutter_application_14/models/cart_item.dart';
import 'package:flutter_application_14/models/product.dart';
import 'package:flutter_application_14/models/order.dart';
import 'package:flutter_application_14/models/address.dart';
import 'package:uuid/uuid.dart';


class AppProvider extends ChangeNotifier {
  final List<Product> _products = dummyProducts;
  final List<CartItem> _cartItems = [];
  final Set<String> _favoriteIds = {};
  
  // Auth State
  bool _isLoggedIn = false;
  String _userFullName = "Jammie"; // Default for demo

  bool get isLoggedIn => _isLoggedIn;
  String get userFullName => _userFullName;

  // Theme State
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void login(String name) {
    _isLoggedIn = true;
    if (name.isNotEmpty) {
      _userFullName = name;
    }
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userFullName = "Guest";
    notifyListeners();
  }
  
  // Order State
  final List<Order> _orders = [];

  // Address State
  final List<Address> _addresses = [
    Address(
      id: '1', 
      title: 'Home', 
      fullName: 'John Doe',
      phoneNumber: '1234567890',
      pincode: '10001',
      state: 'New York',
      city: 'New York',
      houseNo: '123',
      roadName: 'Main Street',
      isDefault: true
    ),
  ];

  List<Product> get products => _products;
  List<CartItem> get cartItems => _cartItems;
  List<Order> get orders => [..._orders];
  List<Address> get addresses => [..._addresses];
  
  // Favorites
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  List<Product> get favoriteProducts {
    return _products.where((p) => _favoriteIds.contains(p.id)).toList();
  }

  // Cart
  void addToCart(Product product, double size) {
    // Check if item already exists with same product and size
    int index = _cartItems.indexWhere((item) => item.product.id == product.id && item.size == size);
    
    if (index >= 0) {
      _cartItems[index].quantity++;
    } else {
      _cartItems.add(CartItem(product: product, size: size));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void incrementCartItem(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrementCartItem(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _cartItems.remove(item);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get subtotal {
    return _cartItems.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  }
  // --- Order Logic ---

  void addOrder(double total) {
    if (_cartItems.isEmpty) return;

    _orders.insert(0, Order(
      id: const Uuid().v4(),
      items: List.from(_cartItems),
      totalAmount: total,
      date: DateTime.now(),
    ));

    clearCart();
    notifyListeners();
  }

  // --- Address Logic ---

  void addAddress({
    required String title,
    required String fullName,
    required String phoneNumber,
    required String pincode,
    required String state,
    required String city,
    required String houseNo,
    required String roadName,
  }) {
    final newAddress = Address(
      id: const Uuid().v4(),
      title: title,
      fullName: fullName,
      phoneNumber: phoneNumber,
      pincode: pincode,
      state: state,
      city: city,
      houseNo: houseNo,
      roadName: roadName,
      isDefault: _addresses.isEmpty,
    );
    _addresses.add(newAddress);
    notifyListeners();
  }

  void updateAddress({
    required String id,
    required String title,
    required String fullName,
    required String phoneNumber,
    required String pincode,
    required String state,
    required String city,
    required String houseNo,
    required String roadName,
  }) {
    final index = _addresses.indexWhere((addr) => addr.id == id);
    if (index >= 0) {
      _addresses[index] = Address(
        id: id,
        title: title,
        fullName: fullName,
        phoneNumber: phoneNumber,
        pincode: pincode,
        state: state,
        city: city,
        houseNo: houseNo,
        roadName: roadName,
        isDefault: _addresses[index].isDefault,
      );
      notifyListeners();
    }
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((addr) => addr.id == id);
    notifyListeners();
  }
}
