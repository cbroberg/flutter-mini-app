# Flutter Fruit App 🍎

A modern Flutter mini-app that demonstrates best practices in state management, UI design, and project structure. The app displays a list of fruits with detailed information for each fruit.

## Features

- **Fruit List Screen**: Browse through a curated list of fruits with images, descriptions, and quick information
- **Detail Screen**: View comprehensive information about each fruit including nutritional details
- **Riverpod State Management**: Modern, efficient state management using Riverpod
- **Responsive Design**: Beautiful UI that works across different device sizes
- **Image Loading**: Network image loading with error handling
- **Material 3 Design**: Uses Flutter's latest Material 3 design system

## Project Structure

```
flutter-mini-app/
├── lib/
│   ├── main.dart              # App entry point and root widget
│   ├── providers/
│   │   └── fruit_provider.dart # Riverpod providers and Fruit model
│   └── screens/
│       ├── home_screen.dart    # Fruit list display
│       └── detail_screen.dart  # Fruit detail view
├── pubspec.yaml               # Flutter dependencies and configuration
├── .gitignore                 # Git ignore rules for Flutter
├── LICENSE                    # MIT License
└── README.md                  # This file
```

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (included with Flutter)
- An IDE (Android Studio, VS Code, or IntelliJ)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter-fruit-app.git
   cd flutter-fruit-app
   ```

2. **Get Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Running on Different Platforms

- **iOS (macOS only)**
  ```bash
  flutter run -d ios
  ```

- **Android**
  ```bash
  flutter run -d android
  ```

- **Web**
  ```bash
  flutter run -d chrome
  ```

## Dependencies

The project uses the following key dependencies:

- **flutter_riverpod**: State management solution
  - Provides reactive state container for managing app state
  - Easy-to-use provider pattern with compile-time safety

- **google_fonts**: Beautiful fonts from Google Fonts
  - Optional enhancement for typography

## Project Architecture

### State Management (Riverpod)

The app uses Riverpod for state management with the following providers:

1. **fruitListProvider**: Provides the static list of all fruits
2. **selectedFruitProvider**: Manages the currently selected fruit
3. **currentFruitProvider**: Computed provider that watches selectedFruitProvider

This demonstrates both simple and computed providers in Riverpod.

### Screens

1. **HomeScreen**:
   - Displays list of all fruits using ListView.builder
   - Each fruit is shown in a FruitCard widget
   - Handles navigation to detail screen
   - Uses Riverpod to watch and update selected fruit state

2. **DetailScreen**:
   - Shows comprehensive fruit information
   - Displays fruit image, description, and nutritional info
   - Includes quick facts and color badge
   - Responsive layout with SingleChildScrollView

### Data Model

The `Fruit` class in `fruit_provider.dart` represents a fruit with:
- `id`: Unique identifier
- `name`: Fruit name
- `description`: Brief description
- `imageUrl`: Network image URL
- `color`: Fruit color/appearance
- `nutritionalInfo`: Nutritional information

## Code Style & Best Practices

This project follows Flutter best practices:

1. **Naming Conventions**:
   - Classes: PascalCase (e.g., `HomeScreen`)
   - Variables/functions: camelCase (e.g., `selectedFruit`)
   - Files: snake_case (e.g., `home_screen.dart`)

2. **Widget Organization**:
   - Private widgets prefixed with `_` (e.g., `_FruitCard`)
   - Single responsibility principle
   - Reusable component widgets

3. **Code Comments**:
   - Class-level documentation with `///`
   - Section comments for major logic blocks
   - Inline comments for non-obvious implementation details

4. **Error Handling**:
   - Image loading error fallback UI
   - Null safety with proper type annotations
   - Null coalescing for fallback values

5. **State Management**:
   - Provider pattern for dependency injection
   - Reactive updates using Riverpod watchers
   - Clear separation of business logic from UI

## Usage Example

### Navigating to Fruit Details

```dart
// When a user taps a fruit card:
ref.read(selectedFruitProvider.notifier).state = fruit;
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const DetailScreen(),
  ),
);
```

### Watching State in UI

```dart
// In any ConsumerWidget:
final selectedFruit = ref.watch(currentFruitProvider);
```

## Extending the App

### Adding a Search Feature

You can extend the `fruitListProvider` to support filtering:

```dart
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredFruitsProvider = Provider<List<Fruit>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final allFruits = ref.watch(fruitListProvider);
  return allFruits
      .where((fruit) => fruit.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
});
```

### Connecting to a Backend API

Replace the static list in `fruitListProvider` with an API call:

```dart
final fruitListProvider = FutureProvider<List<Fruit>>((ref) async {
  final response = await http.get(Uri.parse('https://api.example.com/fruits'));
  return parseResponse(response);
});
```

## Testing

To run the test suite (when tests are added):

```bash
flutter test
```

## Troubleshooting

### Images not loading
- Check your internet connection
- Verify the image URLs are valid
- The app includes error handling with fallback UI

### Dependency conflicts
- Run `flutter pub upgrade` to update dependencies
- Clear build cache: `flutter clean`

## Performance Tips

1. Use `const` constructors for widgets
2. Leverage Riverpod's caching with immutable models
3. Use `ConsumerWidget` instead of `StatefulWidget` when using Riverpod
4. Implement lazy loading for larger lists with `ListView.builder`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Material Design 3](https://m3.material.io)

---

**Made with ❤️ using Flutter and Riverpod**