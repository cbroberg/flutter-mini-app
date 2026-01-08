import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fruit_provider.dart';

/// DetailScreen displays detailed information about a selected fruit.
/// Shows the fruit image, full description, nutritional information,
/// and other details retrieved from the Riverpod state.
class DetailScreen extends ConsumerWidget {
  const DetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current fruit provider to get selected fruit details
    final selectedFruit = ref.watch(currentFruitProvider);

    // If no fruit is selected, show a fallback screen
    if (selectedFruit == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Fruit Details'),
        ),
        body: const Center(
          child: Text('No fruit selected'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedFruit.name),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Fruit image hero section
            _FruitImageSection(fruit: selectedFruit),

            /// Fruit details content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Fruit name and color badge
                  _FruitHeader(fruit: selectedFruit),
                  const SizedBox(height: 24),

                  /// Description section
                  _SectionTitle(title: 'Description'),
                  const SizedBox(height: 8),
                  Text(
                    selectedFruit.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Nutritional information section
                  _SectionTitle(title: 'Nutritional Information'),
                  const SizedBox(height: 8),
                  _InformationCard(
                    content: selectedFruit.nutritionalInfo,
                  ),
                  const SizedBox(height: 24),

                  /// Quick facts section
                  _SectionTitle(title: 'Quick Facts'),
                  const SizedBox(height: 12),
                  _QuickFactTile(label: 'Color', value: selectedFruit.color),
                  const SizedBox(height: 8),
                  _QuickFactTile(label: 'Fruit ID', value: '#${selectedFruit.id}'),
                  const SizedBox(height: 32),

                  /// Action buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Back to List',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget that displays the fruit image in a hero section with gradient overlay.
class _FruitImageSection extends StatelessWidget {
  final Fruit fruit;

  const _FruitImageSection({required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Fruit image
        Image.network(
          fruit.imageUrl,
          width: double.infinity,
          height: 300,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported, size: 64),
            );
          },
        ),
        /// Gradient overlay at the bottom for better text readability
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget that displays the fruit name and color badge.
class _FruitHeader extends StatelessWidget {
  final Fruit fruit;

  const _FruitHeader({required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Fruit name
        Text(
          fruit.name,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        /// Color badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            fruit.color,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Reusable section title widget for organizing content.
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Card widget for displaying information with a styled background.
class _InformationCard extends StatelessWidget {
  final String content;

  const _InformationCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 14,
          height: 1.6,
          color: Colors.grey,
        ),
      ),
    );
  }
}

/// Widget that displays a quick fact as a label-value pair.
class _QuickFactTile extends StatelessWidget {
  final String label;
  final String value;

  const _QuickFactTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
