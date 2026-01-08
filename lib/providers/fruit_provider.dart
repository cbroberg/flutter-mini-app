import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
final fruitListProvider = Provider<List<Fruit>>((ref) {
  return [
    Fruit(
      id: 1,
      name: 'Apple',
      description: 'A crisp and sweet fruit with a vibrant red color.',
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/09/09/17/42/apple-1656993_640.jpg',
      color: 'Red',
      nutritionalInfo:
          'Rich in vitamin C and fiber. Low in calories (52 per 100g).',
    ),
    Fruit(
      id: 2,
      name: 'Banana',
      description: 'A creamy and naturally sweet tropical fruit.',
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/05/31/14/38/bananas-791519_640.jpg',
      color: 'Yellow',
      nutritionalInfo:
          'High in potassium and vitamin B6. Energy-rich (89 cal per 100g).',
    ),
    Fruit(
      id: 3,
      name: 'Orange',
      description:
          'A citrus fruit known for its bright orange color and tangy taste.',
      imageUrl:
          'https://cdn.pixabay.com/photo/2015/08/22/13/44/orange-898082_640.jpg',
      color: 'Orange',
      nutritionalInfo:
          'Excellent source of vitamin C. About 47 calories per 100g.',
    ),
    Fruit(
      id: 4,
      name: 'Strawberry',
      description: 'Sweet berries packed with seeds and a delightful flavor.',
      imageUrl:
          'https://cdn.pixabay.com/photo/2012/04/11/17/13/strawberries-30088_640.jpg',
      color: 'Red',
      nutritionalInfo:
          'Low calorie (32 cal/100g), high in vitamin C and antioxidants.',
    ),
    Fruit(
      id: 5,
      name: 'Mango',
      description: 'The "king of fruits" with a sweet and creamy flavor.',
      imageUrl:
          'https://cdn.pixabay.com/photo/2020/05/20/20/23/mango-5197788_640.jpg',
      color: 'Yellow-Orange',
      nutritionalInfo:
          'Rich in vitamin A and C. Contains 60 calories per 100g.',
    ),
    Fruit(
      id: 6,
      name: 'Blueberry',
      description: 'Tiny antioxidant-rich berries with a sweet-tart flavor.',
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/05/19/23/21/blueberries-1403135_640.jpg',
      color: 'Blue',
      nutritionalInfo: 'Superb antioxidant source. Only 57 calories per 100g.',
    ),
  ];
});

/// Notifier to manage selected fruit.
class SelectedFruitNotifier extends Notifier<Fruit?> {
  @override
  Fruit? build() {
    return null;
  }

  void setSelected(Fruit? fruit) {
    state = fruit;
  }
}

/// Provider that selects a specific fruit by its ID.
final selectedFruitProvider =
    NotifierProvider<SelectedFruitNotifier, Fruit?>(() {
  return SelectedFruitNotifier();
});

/// Provider that returns the currently selected fruit details.
final currentFruitProvider = Provider<Fruit?>((ref) {
  return ref.watch(selectedFruitProvider);
});

/// Notifier to manage search query.
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() {
    return '';
  }

  void setQuery(String query) {
    state = query;
  }
}

/// Provider that holds the current search query entered by the user.
final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(() {
  return SearchQueryNotifier();
});

/// Notifier to manage the set of favorite fruit IDs using Riverpod 3.x API.
class FavoriteFruitsNotifier extends Notifier<Set<int>> {
  late SharedPreferences _prefs;

  @override
  Set<int> build() {
    _init();
    return {};
  }

  /// Asynchronously initialize and load favorites from storage.
  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final favoriteIds = _prefs.getStringList('favoriteFruits');
    if (favoriteIds != null) {
      state = favoriteIds.map((id) => int.parse(id)).toSet();
    }
  }

  /// Save the current list of favorites to storage.
  Future<void> _saveFavorites() async {
    final favoriteIds = state.map((id) => id.toString()).toList();
    await _prefs.setStringList('favoriteFruits', favoriteIds);
  }

  /// Toggles the favorite status for a given fruit ID.
  void toggleFavorite(int fruitId) {
    if (state.contains(fruitId)) {
      state = state.where((id) => id != fruitId).toSet();
    } else {
      state = {...state, fruitId};
    }
    _saveFavorites();
  }

  /// Clears all favorite fruits.
  void clearFavorites() {
    state = {};
    _saveFavorites();
  }
}

/// Provider to expose the FavoriteFruitsNotifier (Riverpod 3.x API).
final favoriteFruitsProvider =
    NotifierProvider<FavoriteFruitsNotifier, Set<int>>(() {
  return FavoriteFruitsNotifier();
});

/// Notifier to control the visibility of favorite fruits.
class FavoriteFilterNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void toggle() {
    state = !state;
  }
}

/// Provider to control the visibility of favorite fruits.
/// When true, only favorite fruits are shown.
final favoriteFilterProvider =
    NotifierProvider<FavoriteFilterNotifier, bool>(() {
  return FavoriteFilterNotifier();
});
