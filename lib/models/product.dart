import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final List<String> gallery;
  final List<double> sizes;
  final List<Color> colors;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.gallery,
    required this.sizes,
    required this.colors,
    required this.rating,
  });
}
