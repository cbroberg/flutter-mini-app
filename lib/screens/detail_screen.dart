import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/fruit_provider.dart';
import '../fruit_utils.dart';

/// DetailScreen displays detailed information about a selected fruit.
/// Shows the fruit image, full description, nutritional information,
/// and other details retrieved from the Riverpod state.
///
/// Keyboard support: Press ESC to return to the list (Web & macOS only).
class DetailScreen extends ConsumerStatefulWidget {
  final Fruit fruit;

  const DetailScreen({super.key, required this.fruit});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late FocusNode _focusNode;

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

  /// Handle keyboard input (ESC key) to go back to list.
  /// Only works on Web and macOS platforms.
  /// Returns KeyEventResult.handled if ESC was pressed.
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Only enable keyboard shortcuts on Web and macOS (platforms with keyboards)
    if (!_isKeyboardPlatform()) return KeyEventResult.ignored;

    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
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
    // Watch the current fruit provider to get selected fruit details
    final favoriteFruitIds = ref.watch(favoriteFruitsProvider);
    final isFavorite = favoriteFruitIds.contains(widget.fruit.id);

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

    return Focus(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: _buildScaffold(context, selectedFruit, isFavorite),
    );
  }

  /// Build the main scaffold widget.
  Widget _buildScaffold(
    BuildContext context,
    Fruit selectedFruit,
    bool isFavorite,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            stretch: true,
            backgroundColor: getFruitColor(selectedFruit.name),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                selectedFruit.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              background: _FruitImageSection(fruit: selectedFruit),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red.shade400 : Colors.white,
                ),
                onPressed: () {
                  ref
                      .read(favoriteFruitsProvider.notifier)
                      .toggleFavorite(selectedFruit.id);
                },
                tooltip: 'Toggle Favorite',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Fruit name and color badge
                  _FruitHeader(fruit: selectedFruit),
                  const SizedBox(height: 24),

                  /// Description section
                  const _SectionTitle(title: 'Description'),
                  const SizedBox(height: 8),
                  Text(
                    selectedFruit.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: Colors.black54,
                        ),
                  ),
                  const SizedBox(height: 24),

                  /// Nutritional information section
                  const _SectionTitle(title: 'Nutritional Information'),
                  const SizedBox(height: 8),
                  _InformationCard(
                    content: selectedFruit.nutritionalInfo,
                  ),
                  const SizedBox(height: 24),

                  /// Quick facts section
                  const _SectionTitle(title: 'Quick Facts'),
                  const SizedBox(height: 12),
                  _QuickFactTile(label: 'Color', value: selectedFruit.color),
                  const SizedBox(height: 8),
                  _QuickFactTile(
                      label: 'Fruit ID', value: '#${selectedFruit.id}'),
                  const SizedBox(height: 32),

                  /// Action buttons
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonal(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Back to List',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
    return Hero(
      tag: 'fruit-icon-${fruit.id}',
      child: Container(
        width: double.infinity,
        height: 300,
        decoration: BoxDecoration(
          color: getFruitColor(fruit.name),
        ),
        child: Center(
          child: Icon(
            getFruitIcon(fruit.name),
            size: 120,
            color: Colors.white.withOpacity(0.9),
            shadows: [
              Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 12)
            ],
          ),
        ),
      ),
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
        /// Fruit name (with Hero)
        Hero(
          tag: 'fruit-name-${fruit.id}',
          child: Material(
            color: Colors.transparent,
            child: Text(
              fruit.name,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),

        /// Color badge
        Chip(
          label: Text(fruit.color),
          backgroundColor: Colors.blue.shade100,
          side: BorderSide.none,
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
      style: Theme.of(context)
          .textTheme
          .titleLarge
          ?.copyWith(fontWeight: FontWeight.bold),
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
        color: Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: Colors.black87,
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
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Colors.black54),
        ),
        Text(
          value,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
