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
      imageUrl: 'https://cdn.pixabay.com/photo/2016/09/09/17/42/apple-1656993_640.jpg',
      color: 'Red',
      nutritionalInfo: 'Rich in vitamin C and fiber. Low in calories (52 per 100g).',
    ),
    Fruit(
      id: 2,
      name: 'Banana',
      description: 'A creamy and naturally sweet tropical fruit.',
      imageUrl: 'https://cdn.pixabay.com/photo/2015/05/31/14/38/bananas-791519_640.jpg',
      color: 'Yellow',
      nutritionalInfo: 'High in potassium and vitamin B6. Energy-rich (89 cal per 100g).',
    ),
    Fruit(
      id: 3,
      name: 'Orange',
      description: 'A citrus fruit known for its bright orange color and tangy taste.',
      imageUrl: 'https://cdn.pixabay.com/photo/2015/08/22/13/44/orange-898082_640.jpg',
      color: 'Orange',
      nutritionalInfo: 'Excellent source of vitamin C. About 47 calories per 100g.',
    ),
    Fruit(
      id: 4,
      name: 'Strawberry',
      description: 'Sweet berries packed with seeds and a delightful flavor.',
      imageUrl: 'https://cdn.pixabay.com/photo/2012/04/11/17/13/strawberries-30088_640.jpg',
      color: 'Red',
      nutritionalInfo: 'Low calorie (32 cal/100g), high in vitamin C and antioxidants.',
    ),
    Fruit(
      id: 5,
      name: 'Mango',
      description: 'The "king of fruits" with a sweet and creamy flavor.',
      imageUrl: 'https://cdn.pixabay.com/photo/2020/05/20/20/23/mango-5197788_640.jpg',
      color: 'Yellow-Orange',
      nutritionalInfo: 'Rich in vitamin A and C. Contains 60 calories per 100g.',
    ),
    Fruit(
      id: 6,
      name: 'Blueberry',
      description: 'Tiny antioxidant-rich berries with a sweet-tart flavor.',
      imageUrl: 'https://cdn.pixabay.com/photo/2016/05/19/23/21/blueberries-1403135_640.jpg',
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
