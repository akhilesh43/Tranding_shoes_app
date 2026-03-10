import 'package:flutter_application_14/models/product.dart';

class CartItem {
  final Product product;
  int quantity;
  final double size;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.size,
  });
}
