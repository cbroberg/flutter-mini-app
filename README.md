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

## Project Status

✅ **Fully Functional Multi-Platform App**

- ✅ iOS Simulator support (requires macOS + Xcode + CocoaPods)
- ✅ Android Emulator support (requires Android Studio)
- ✅ Chrome Web support (fully functional)
- ✅ macOS Desktop support (platform files generated)
- ✅ Riverpod 3.x state management (NotifierProvider pattern)
- ✅ Search functionality with favorites
- ✅ Persistent favorites storage (SharedPreferences)
- ✅ Material 3 design
- ✅ Complete documentation and comments

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0.0 or higher)
- Dart SDK (included with Flutter)
- An IDE (Android Studio, VS Code, or IntelliJ)

**Platform-specific requirements:**
- **iOS**: macOS with Xcode, CocoaPods installed
- **Android**: Android Studio with Android SDK, Android Emulator
- **Web**: Chrome browser installed
- **macOS**: Xcode command line tools

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

3. **Run the app (auto-detects available devices)**
   ```bash
   flutter run
   ```

## Running on Different Platforms

### iOS Simulator (macOS only)

**Start iOS Simulator:**
```bash
open -a Simulator
```

**Run app on iOS:**
```bash
flutter run -d ios
```

Or with specific device ID:
```bash
flutter run -d 7F5207CD-59FF-4696-AC4D-3E03651D2567
```

**List available iOS devices:**
```bash
flutter devices
```

---

### Android Emulator

**Start Android Emulator:**
```bash
flutter emulators --launch <emulator_name>
```

**Example (Pixel 6 Pro API 34):**
```bash
flutter emulators --launch sdk_gphone64_arm64:latest
```

**Run app on Android:**
```bash
flutter run -d android
```

Or with specific device ID:
```bash
flutter run -d emulator-5554
```

**List available Android emulators:**
```bash
flutter emulators
```

---

### Chrome Web

**Run app in Chrome:**
```bash
flutter run -d chrome
```

**Access via URL:**
```
http://localhost:xxxxx
```
(URL printed in terminal after app starts)

---

### macOS Desktop

**Run app on macOS:**
```bash
flutter run -d macos
```

---

## Utility Commands

### General Commands

```bash
# Check Flutter & Dart versions
flutter --version

# Verify all platforms are set up correctly
flutter doctor

# List all connected/available devices
flutter devices

# Get/update dependencies
flutter pub get
flutter pub upgrade

# Clean build cache
flutter clean

# Run tests
flutter test

# Build release APK (Android)
flutter build apk

# Build release IPA (iOS)
flutter build ios

# Build web release
flutter build web
```

### Development Commands

```bash
# Run with hot reload support
flutter run

# Run and keep debug output visible
flutter run -v

# Run with specific device
flutter run -d <device_id>

# Format code (Dart style guide)
flutter format .

# Analyze code for issues
flutter analyze

# Run a specific Dart file
flutter run -t lib/main.dart
```

### Hot Reload During Development

When running `flutter run`, you can use interactive commands:

```
r          Hot reload (reload code without losing state)
R          Hot restart (full app restart)
h          Show help menu
w          Show widget hierarchy
t          Toggle debug paint
L          Show performance overlay
P          Toggle performance overlay
i          Show instrumentation info
q          Quit
```

### CocoaPods (iOS dependency management)

```bash
# Install CocoaPods (if not already installed)
sudo gem install cocoapods

# Install iOS dependencies
cd ios
pod install
cd ..

# Clean CocoaPods cache
rm -rf Pods
rm Podfile.lock
pod install
```

### Android Commands

```bash
# Clean Android build
cd android
./gradlew clean
cd ..

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Uninstall app from device
flutter uninstall
```

## Dependencies

The project uses the following key dependencies:

- **riverpod** (^2.4.0): Core Riverpod package
  - Lightweight state management without UI dependencies
  - Used by flutter_riverpod

- **flutter_riverpod** (^2.4.0): Flutter integration for Riverpod
  - Provides reactive state container for managing app state
  - ConsumerWidget and ConsumerStatefulWidget for widget integration
  - Provider pattern with compile-time safety
  - NotifierProvider for complex state management

- **shared_preferences** (^2.5.4): Persistent local storage
  - Stores user favorites across app restarts
  - Platform-specific implementation (NSUserDefaults on iOS, SharedPreferences on Android)

- **google_fonts** (^7.0.0): Beautiful fonts from Google Fonts
  - Optional enhancement for typography

## Project Architecture

### State Management (Riverpod 3.x)

The app uses Riverpod for state management with the following providers:

**Core Providers:**
1. **fruitListProvider** (`Provider`): Static list of all available fruits
2. **selectedFruitProvider** (`NotifierProvider<SelectedFruitNotifier, Fruit?>`): Manages currently selected fruit
3. **currentFruitProvider** (`Provider`): Computed provider that watches selectedFruitProvider

**Search & Filter Providers:**
4. **searchQueryProvider** (`NotifierProvider<SearchQueryNotifier, String>`): Manages user's search query
5. **favoriteFilterProvider** (`NotifierProvider<FavoriteFilterNotifier, bool>`): Toggles between showing all fruits vs. favorites only

**Favorites Management:**
6. **favoriteFruitsProvider** (`NotifierProvider<FavoriteFruitsNotifier, Set<int>>`):
   - Manages set of favorite fruit IDs
   - Persists to local storage (SharedPreferences)
   - Survives app restarts

**Advanced Patterns Used:**
- `Notifier` base class for stateful providers (Riverpod 3.x pattern)
- `NotifierProvider` for providers with methods
- Async initialization with `_init()` for loading persisted data
- Combining multiple providers for filtering and sorting logic

### Screens

1. **HomeScreen** (`ConsumerStatefulWidget`):
   - Displays filterable list of fruits using AnimatedList
   - Search bar in AppBar for real-time fruit filtering
   - Favorite filter toggle button (show all vs. favorites only)
   - Each fruit shown in FruitCard with:
     - Colored icon (no network images - avoids CORS issues on web)
     - Name, description, and color tag
     - Heart icon to toggle favorite status
   - Favorites appear first, then sorted alphabetically
   - Smooth animations when adding/removing items
   - Menu to clear all favorites with confirmation dialog
   - Uses Riverpod to watch and update multiple providers

2. **DetailScreen** (`ConsumerWidget`):
   - Shows comprehensive fruit information
   - Gradient background with large fruit icon (Hero animation)
   - Full description and nutritional information
   - Quick facts (color, fruit ID)
   - Responsive layout with SingleChildScrollView
   - Back button to return to list

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

### Already Implemented Features

The app already includes:
- ✅ Real-time search functionality
- ✅ Favorite fruits system with persistence
- ✅ Filter by favorites
- ✅ Sorted list (favorites first, then alphabetically)
- ✅ Animated list transitions

### Potential Enhancements

#### 1. Connecting to a Backend API

Replace the static list in `fruitListProvider` with an API call:

```dart
final fruitListProvider = FutureProvider<List<Fruit>>((ref) async {
  final response = await http.get(Uri.parse('https://api.example.com/fruits'));
  return parseResponse(response);
});
```

#### 2. Add Fruit Categories

```dart
class Fruit {
  // ... existing fields
  final String category; // 'Citrus', 'Berries', 'Tropical', etc.
}

final fruitCategoryProvider = StateProvider<String?>((ref) => null);

final filteredByCategory = Provider<List<Fruit>>((ref) {
  final category = ref.watch(fruitCategoryProvider);
  final fruits = ref.watch(fruitListProvider);

  if (category == null) return fruits;
  return fruits.where((f) => f.category == category).toList();
});
```

#### 3. Add Nutritional Info Detail Page

Create a new `NutritionScreen` to show detailed nutritional breakdown with charts.

#### 4. Dark Mode Support

```dart
final darkModeProvider = StateProvider<bool>((ref) => false);

// Use in ThemeData
ThemeData.light() // or ThemeData.dark()
```

#### 5. Multi-Language Support

Use package like `easy_localization` to support multiple languages.

#### 6. Recipe Suggestions

Add a new provider to suggest recipes based on selected fruit:

```dart
final recipesProvider = FutureProvider<List<Recipe>>((ref) async {
  final selectedFruit = ref.watch(currentFruitProvider);
  if (selectedFruit == null) return [];

  return fetchRecipes(selectedFruit.id);
});
```

## Testing

To run the test suite (when tests are added):

```bash
flutter test
```

## Troubleshooting

### iOS Build Issues

**Error: CocoaPods not installed**
```bash
sudo gem install cocoapods
```

**Error: Pod install issues**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter pub get
```

### Android Build Issues

**Error: Gradle build failed**
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run -d android
```

### Common Issues

**Hot reload not working:**
- Press `R` for hot restart instead
- Or stop and restart `flutter run`

**Device not detected:**
```bash
flutter devices  # List all devices
flutter emulators  # List Android emulators
```

**Build cache issues:**
```bash
flutter clean
flutter pub get
flutter run
```

**Dependencies conflicting:**
- Run `flutter pub upgrade` to update dependencies
- Update pubspec.yaml to latest versions

### Platform-Specific Issues

**iOS Simulator:** Requires macOS with Xcode installed
**Android Emulator:** Requires Android Studio + Android SDK
**Web:** Works in any modern browser (Chrome recommended)

### Images not displaying
- The app uses colored icons instead of network images
- Avoids CORS issues on web platform
- If you modify to use network images, ensure proper error handling

## Performance Tips

1. Use `const` constructors for widgets
2. Leverage Riverpod's caching with immutable models
3. Use `ConsumerWidget` instead of `StatefulWidget` when using Riverpod
4. Implement lazy loading for larger lists with `ListView.builder`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Development Notes

### Project History

This project was bootstrapped using Flutter best practices and evolved through several iterations:

1. **Initial Setup**: Created basic Flutter project with Material 3 design
2. **Platform Support**: Added iOS, Android, Web, and macOS support
3. **State Management**: Implemented Riverpod 3.x with NotifierProvider pattern
4. **Features**: Added search, favorites, and persistent storage
5. **Fixes**: Resolved Riverpod API migration issues (StateProvider → NotifierProvider)
6. **Polish**: Added animations, error handling, and comprehensive documentation

### Key Learnings

- **Riverpod 3.x Breaking Changes**: The API shifted from `StateNotifier`/`StateNotifierProvider` to `Notifier`/`NotifierProvider`
- **Web CORS Issues**: Solved by using colored icons instead of network images
- **CocoaPods Challenges**: iOS required Ruby 3.3.0+ for CocoaPods installation
- **Hot Reload**: Essential for rapid development iteration across all platforms

### Technology Stack

- **Framework**: Flutter 3.0+
- **State Management**: Riverpod 3.1.0+ (modern Notifier pattern)
- **Local Storage**: SharedPreferences
- **UI System**: Material 3 with custom theming
- **Languages**: Dart 3.0+
- **Platforms**: iOS, Android, Web, macOS

## Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Documentation](https://riverpod.dev)
- [Flutter Best Practices](https://flutter.dev/docs/testing/best-practices)
- [Material Design 3](https://m3.material.io)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)

---

**Made with ❤️ using Flutter and Riverpod**

Last updated: January 2026