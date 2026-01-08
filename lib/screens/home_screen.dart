import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fruit_provider.dart';
import '../fruit_utils.dart';
import 'detail_screen.dart';

/// HomeScreen displays a list of all available fruits.
/// Users can tap on a fruit to navigate to the detail screen.
/// Uses Riverpod to manage the list of fruits and selected fruit state.
///
/// Keyboard support (Web & macOS only):
/// - ENTER: Opens detail screen for focused fruit
/// - SPACE: Toggles favorite status for focused fruit
/// - Arrow Up/Down: Navigate between fruits
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late List<Fruit> _filteredFruits;
  late FocusNode _focusNode;
  int _focusedFruitIndex = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    // Request focus so keyboard events are captured
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _filteredFruits = _getFilteredAndSortedFruits();
  }

  List<Fruit> _getFilteredAndSortedFruits() {
    // Watch the fruit list provider to get all fruits
    final allFruits = ref.watch(fruitListProvider);
    // Watch the search query provider
    final searchQuery = ref.watch(searchQueryProvider);
    // Watch the favorite filter provider
    final showFavoritesOnly = ref.watch(favoriteFilterProvider);
    // Watch the favorite fruits provider
    final favoriteFruitIds = ref.watch(favoriteFruitsProvider);
    final hasFavorites = favoriteFruitIds.isNotEmpty;

    // Filter fruits based on the search query and favorite filter
    var filteredFruits = allFruits.where((fruit) {
      final matchesSearch =
          fruit.name.toLowerCase().contains(searchQuery.toLowerCase());
      if (showFavoritesOnly) {
        final isFavorite = favoriteFruitIds.contains(fruit.id);
        return isFavorite && matchesSearch;
      }
      return matchesSearch;
    }).toList();

    // Sort the list to show favorites first, then alphabetically.
    // This applies whether the favorite filter is on or off.
    filteredFruits.sort((a, b) {
      final isAFavorite = favoriteFruitIds.contains(a.id);
      final isBFavorite = favoriteFruitIds.contains(b.id);

      if (isAFavorite && !isBFavorite) {
        return -1; // a (favorite) comes before b (not favorite)
      } else if (!isAFavorite && isBFavorite) {
        return 1; // b (favorite) comes after a (not favorite)
      }
      return a.name.compareTo(b.name); // Sort alphabetically otherwise
    });
    return filteredFruits;
  }

  void _updateList() {
    final newFilteredFruits = _getFilteredAndSortedFruits();
    // Find removed items
    for (int i = _filteredFruits.length - 1; i >= 0; i--) {
      if (!newFilteredFruits.contains(_filteredFruits[i])) {
        final removedFruit = _filteredFruits[i];
        _listKey.currentState?.removeItem(
          i,
          (context, animation) => _buildRemovedItem(removedFruit, animation),
        );
      }
    }

    // Find added items
    for (int i = 0; i < newFilteredFruits.length; i++) {
      if (!_filteredFruits.contains(newFilteredFruits[i])) {
        _listKey.currentState?.insertItem(i);
      }
    }

    _filteredFruits = newFilteredFruits;
  }

  /// Handle keyboard input for navigation and actions.
  /// Only works on Web and macOS platforms.
  void _handleKeyEvent(KeyEvent event) {
    // Only enable keyboard shortcuts on Web and macOS
    if (!_isKeyboardPlatform()) return;

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        // ENTER: Open detail screen for focused fruit
        if (_filteredFruits.isNotEmpty &&
            _focusedFruitIndex < _filteredFruits.length) {
          final fruit = _filteredFruits[_focusedFruitIndex];
          ref.read(selectedFruitProvider.notifier).setSelected(fruit);
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailScreen(fruit: fruit)),
          );
        }
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        // SPACE: Toggle favorite for focused fruit
        if (_filteredFruits.isNotEmpty &&
            _focusedFruitIndex < _filteredFruits.length) {
          final fruit = _filteredFruits[_focusedFruitIndex];
          ref
              .read(favoriteFruitsProvider.notifier)
              .toggleFavorite(fruit.id);
        }
      } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        // Arrow Up: Move focus to previous fruit
        setState(() {
          if (_focusedFruitIndex > 0) {
            _focusedFruitIndex--;
          }
        });
      } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        // Arrow Down: Move focus to next fruit
        setState(() {
          if (_focusedFruitIndex < _filteredFruits.length - 1) {
            _focusedFruitIndex++;
          }
        });
      }
    }
  }

  /// Check if the current platform supports keyboard input.
  /// Returns true for Web and macOS, false for iOS and Android.
  bool _isKeyboardPlatform() {
    return kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.android);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to providers to trigger list updates
    ref.listen(searchQueryProvider, (_, __) => _updateList());
    ref.listen(favoriteFilterProvider, (_, __) => _updateList());
    ref.listen(favoriteFruitsProvider, (_, __) => _updateList());

    final showFavoritesOnly = ref.watch(favoriteFilterProvider);
    final hasFavorites = ref.watch(favoriteFruitsProvider).isNotEmpty;

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (query) {
            ref.read(searchQueryProvider.notifier).setQuery(query);
          },
          decoration: InputDecoration(
            hintText: 'Search for a fruit...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showFavoritesOnly ? Icons.filter_list : Icons.filter_list_off,
              color: Colors.white,
            ),
            tooltip: 'Show Favorites Only',
            onPressed: () {
              // Toggle the favorite filter
              ref.read(favoriteFilterProvider.notifier).toggle();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear_favorites') {
                // Show a confirmation dialog before clearing
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Clear All Favorites'),
                      content: const Text(
                          'Are you sure you want to remove all your favorite fruits?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(dialogContext)
                                .pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: const Text('Clear'),
                          onPressed: () {
                            ref
                                .read(favoriteFruitsProvider.notifier)
                                .clearFavorites();
                            Navigator.of(dialogContext)
                                .pop(); // Close the dialog
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'clear_favorites',
                enabled: hasFavorites,
                child: const Text('Clear all favorites'),
              ),
            ],
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: _filteredFruits.isEmpty
          ? const Center(child: Text('No fruits found'))
          : AnimatedList(
              key: _listKey,
              padding: const EdgeInsets.all(8.0),
              initialItemCount: _filteredFruits.length,
              itemBuilder: (context, index, animation) {
                final fruit = _filteredFruits[index];
                return SizeTransition(
                  sizeFactor: animation,
                  child: FruitCard(fruit: fruit),
                );
              },
            ),
      ),
    );
  }

  Widget _buildRemovedItem(Fruit fruit, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Opacity(
        opacity: 0.0,
        child: FruitCard(fruit: fruit),
      ),
    );
  }
}

/// FruitCard is a reusable widget that displays a single fruit in a card format.
/// Includes fruit image, name, and a brief description.
/// Tapping the card navigates to the DetailScreen.
class FruitCard extends ConsumerWidget {
  final Fruit fruit;

  const FruitCard({
    super.key,
    required this.fruit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the favorite fruits provider to check if this fruit is a favorite
    final favoriteFruitIds = ref.watch(favoriteFruitsProvider);
    final isFavorite = favoriteFruitIds.contains(fruit.id);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: InkWell(
        onTap: () {
          // Update the selected fruit in state
          ref.read(selectedFruitProvider.notifier).setSelected(fruit);
          // Navigate to the detail screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailScreen(
                fruit: fruit,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              /// Fruit icon with a colored background (instead of network image)
              /// This ensures the app works perfectly on web without CORS issues
              Hero(
                tag: 'fruit-icon-${fruit.id}',
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: getFruitColor(fruit.name),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    getFruitIcon(fruit.name),
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              /// Fruit information section
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Fruit name
                    Hero(
                      tag: 'fruit-name-${fruit.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          fruit.name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Fruit description (truncated)
                    Text(
                      fruit.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),

                    /// Color tag
                    Chip(
                      label: Text(fruit.color),
                      labelStyle: TextStyle(color: Colors.blue.shade800),
                      backgroundColor: Colors.blue.shade100,
                      side: BorderSide.none,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ],
                ),
              ),

              /// Favorite button
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  // Toggle the favorite status
                  ref
                      .read(favoriteFruitsProvider.notifier)
                      .toggleFavorite(fruit.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
