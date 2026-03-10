import 'package:flutter/material.dart';
import 'package:flutter_application_14/models/product.dart';

final List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Nike Air Max 270',
    category: 'Running',
    price: 150.00,
    description: 'The Nike Air Max 270 delivers visible air under every step. Updated for modern comfort, it nods to the original, 1991 Air Max 180 with its exaggerated tongue top and heritage tongue logo.',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Red Nike
    gallery: [],
    sizes: [38, 39, 40, 41, 42],
    colors: [Colors.black, Colors.red, Colors.blue],
    rating: 4.5,
  ),
  Product(
    id: '2',
    name: 'Adidas Ultra Boost',
    category: 'Running',
    price: 180.00,
    description: 'These running shoes combine comfort and high-performance technology for a best-ever-run feeling. They have a stretchy knit upper that adapts to the changing shape of your foot as you run.',
    imageUrl: 'https://images.unsplash.com/photo-1511556532299-8f662fc26c06?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // White/Black running shoe
    gallery: [],
    sizes: [39, 40, 41, 42, 43],
    colors: [Colors.white, Colors.black, Colors.grey],
    rating: 4.8,
  ),
   Product(
    id: '3',
    name: 'Puma RS-X',
    category: 'Lifestyle',
    price: 110.00,
    description: 'The RS-X is back. The future-retro silhouette of this sneaker returns with a progressive aesthetic and angular details, complete with nubuck and suede overlays. The combo’s all about a disruptive design to showcase your disruptive style.',
    imageUrl: 'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Colorful sneaker
    gallery: [],
    sizes: [38, 40, 42],
    colors: [Colors.orange, Colors.blue, Colors.white],
    rating: 4.2,
  ),
  Product(
    id: '4',
    name: 'Air Jordan 1 Low',
    category: 'Basketball',
    price: 140.00,
    description: 'Inspired by the original that debuted in 1985, the Air Jordan 1 Low offers a clean, classic look that\'s familiar yet always fresh. It\'s made for casual mode, with an iconic design that goes with everything and never goes out of style.',
    imageUrl: 'https://images.unsplash.com/photo-1512374382149-233c42b6a83b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // White sneaker
    gallery: [],
    sizes: [40, 41, 42, 43, 44],
    colors: [Colors.white, Colors.red, Colors.black],
    rating: 4.7,
  ),
  ...List.generate(30, (index) {
    const shoeIds = [
      '1542291026-7eec264c27ff',
      '1511556532299-8f662fc26c06',
      '1595950653106-6c9ebd614d3a',
      '1606107557195-0e29a4b5b4aa',
      '1491553895911-0055eca6402d',
      '1600185365483-26d7a4c755ce',
      '1608231387042-66d1773070a5',
      '1560761210-2b5e4c4bd56c',
      '1525966222461-73964bedcbf7',
      '1515955656352-a1bb3ffff111',
      '1552346154-21d32810abb1',
      '1460353581641-37baddab0fa2',
    ];
    final photoId = shoeIds[index % shoeIds.length];
    
    return Product(
      id: 'p_${index + 5}',
      name: 'Premium Runner ${index + 1}',
      category: index % 2 == 0 ? 'Running' : 'Lifestyle',
      price: 100.00 + (index * 5),
      description: 'A high-performance shoe designed for both comfort and style. Featuring advanced cushioning technology and breathable materials.',
      imageUrl: 'https://images.unsplash.com/photo-$photoId?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      gallery: [],
      sizes: [38, 39, 40, 41, 42, 43, 44],
      colors: [Colors.black, Colors.blue, Colors.grey],
      rating: 4.0 + (index % 10) / 10,
    );
  }),
];
