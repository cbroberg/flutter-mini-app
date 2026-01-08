import 'package:flutter/material.dart';

/// Helper function to get the color for a fruit based on its name
Color getFruitColor(String fruitName) {
  switch (fruitName.toLowerCase()) {
    case 'apple':
      return Colors.red.shade500;
    case 'banana':
      return Colors.amber.shade400;
    case 'orange':
      return Colors.orange.shade500;
    case 'strawberry':
      return Colors.red.shade400;
    case 'mango':
      return Colors.orange.shade600;
    case 'blueberry':
      return Colors.blue.shade600;
    default:
      return Colors.grey.shade400;
  }
}

/// Helper function to get the icon for a fruit based on its name
IconData getFruitIcon(String fruitName) {
  switch (fruitName.toLowerCase()) {
    case 'apple':
      return Icons.apple;
    case 'banana':
      return Icons.emoji_food_beverage;
    case 'orange':
      return Icons.circle;
    case 'strawberry':
      return Icons.favorite;
    case 'mango':
      return Icons.circle;
    case 'blueberry':
      return Icons.circle;
    default:
      return Icons.lunch_dining;
  }
}
