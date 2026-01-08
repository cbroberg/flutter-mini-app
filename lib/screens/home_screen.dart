import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fruit_provider.dart';
import 'detail_screen.dart';

/// HomeScreen displays a list of all available fruits.
/// Users can tap on a fruit to navigate to the detail screen.
/// Uses Riverpod to manage the list of fruits and selected fruit state.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the fruit list provider to get all fruits
    final fruits = ref.watch(fruitListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits Store'),
        elevation: 0,
      ),
      body: fruits.isEmpty
          ? const Center(
              child: Text('No fruits available'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                final fruit = fruits[index];
                return FruitCard(fruit: fruit);
              },
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
    Key? key,
    required this.fruit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
      child: InkWell(
        onTap: () {
          // Update the selected fruit in state
          ref.read(selectedFruitProvider.notifier).state = fruit;
          // Navigate to the detail screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DetailScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              /// Fruit image with a rounded container
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  fruit.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              /// Fruit information section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Fruit name
                    Text(
                      fruit.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        fruit.color,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /// Arrow icon indicating navigation
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.blue.shade600,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
