import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Model class representing a Fruit with all necessary information.
class Fruit {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String color;
  final String nutritionalInfo;

  Fruit({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.color,
    required this.nutritionalInfo,
  });
}

/// Provider that returns a list of all available fruits.
/// This is a simple StateProvider for demonstration purposes.
/// In a real app, you might fetch from an API or local database.
final fruitListProvider = Provider<List<Fruit>>((ref) {
  return [
    Fruit(
      id: 1,
      name: 'Apple',
      description: 'A crisp and sweet fruit with a vibrant red color.',
      imageUrl: 'https://images.unsplash.com/photo-1560806887-1ab04cf2d4d4?w=400',
      color: 'Red',
      nutritionalInfo: 'Rich in vitamin C and fiber. Low in calories (52 per 100g).',
    ),
    Fruit(
      id: 2,
      name: 'Banana',
      description: 'A creamy and naturally sweet tropical fruit.',
      imageUrl: 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400',
      color: 'Yellow',
      nutritionalInfo: 'High in potassium and vitamin B6. Energy-rich (89 cal per 100g).',
    ),
    Fruit(
      id: 3,
      name: 'Orange',
      description: 'A citrus fruit known for its bright orange color and tangy taste.',
      imageUrl: 'https://images.unsplash.com/photo-1557803400-c1feb64a53c6?w=400',
      color: 'Orange',
      nutritionalInfo: 'Excellent source of vitamin C. About 47 calories per 100g.',
    ),
    Fruit(
      id: 4,
      name: 'Strawberry',
      description: 'Sweet berries packed with seeds and a delightful flavor.',
      imageUrl: 'https://images.unsplash.com/photo-1464454709131-ffd692591ee5?w=400',
      color: 'Red',
      nutritionalInfo: 'Low calorie (32 cal/100g), high in vitamin C and antioxidants.',
    ),
    Fruit(
      id: 5,
      name: 'Mango',
      description: 'The "king of fruits" with a sweet and creamy flavor.',
      imageUrl: 'https://images.unsplash.com/photo-1601493830173-eba19627ceb2?w=400',
      color: 'Yellow-Orange',
      nutritionalInfo: 'Rich in vitamin A and C. Contains 60 calories per 100g.',
    ),
    Fruit(
      id: 6,
      name: 'Blueberry',
      description: 'Tiny antioxidant-rich berries with a sweet-tart flavor.',
      imageUrl: 'https://images.unsplash.com/photo-1599599810694-cb1fbf6c8c1a?w=400',
      color: 'Blue',
      nutritionalInfo: 'Superb antioxidant source. Only 57 calories per 100g.',
    ),
  ];
});

/// Provider that selects a specific fruit by its ID.
/// Used for displaying fruit details on the detail screen.
final selectedFruitProvider = StateProvider<Fruit?>((ref) => null);

/// Provider that returns the currently selected fruit details.
/// This demonstrates computed state based on the selectedFruitProvider.
final currentFruitProvider = Provider<Fruit?>((ref) {
  return ref.watch(selectedFruitProvider);
});
