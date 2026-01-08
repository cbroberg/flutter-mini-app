import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/home_screen.dart';

/// Main entry point of the application.
/// The app is wrapped with ProviderScope to enable Riverpod state management
/// throughout the entire widget tree.
void main() {
  runApp(
    const ProviderScope(
      child: FruitApp(),
    ),
  );
}

/// Root widget of the application.
/// Defines the app theme and navigation structure.
class FruitApp extends StatelessWidget {
  const FruitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Fruit App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use a beautiful blue color scheme as primary
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
