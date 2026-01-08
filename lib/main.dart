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
  const FruitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Fruit App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ).copyWith(
        appBarTheme: AppBarTheme(
          elevation: 0, // Keep it flat
          centerTitle: true,
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
