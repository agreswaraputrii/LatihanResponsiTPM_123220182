// lib/main.dart
import 'package:flutter/material.dart';
import 'package:restaurant_app/pages/home_page.dart';
import 'package:restaurant_app/pages/login_page.dart';
import 'package:restaurant_app/pages/favorite_page.dart';
import 'package:restaurant_app/pages/detail_page.dart';
import 'package:restaurant_app/utils/preferences_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  final PreferencesHelper _prefsHelper = PreferencesHelper();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final username = await _prefsHelper.getUsername();
    setState(() {
      _isLoggedIn = username != null && username.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      // ----------- HILANGKAN DEBUG BANNER DI SINI -----------
      debugShowCheckedModeBanner: false, // <-- Tambahkan baris ini
      // -----------------------------------------------------
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: const Color.fromARGB(255, 0, 0, 0), // Warna primer yang lebih menarik
        hintColor: const Color.fromARGB(255, 0, 0, 0), // Warna aksen
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 0, 0, 0), // Warna app bar
          foregroundColor: Colors.white, // Warna teks di app bar
          elevation: 4, // Sedikit bayangan di app bar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Warna tombol elevated
            foregroundColor: Colors.white, // Warna teks tombol
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bentuk tombol lebih modern
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10), // Sudut input field yang membulat
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2), // Warna border saat fokus
          ),
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
        ),
        cardTheme: CardTheme(
          elevation: 5, // Bayangan pada card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Sudut card yang membulat
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating, // Snackbar terlihat seperti melayang
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _isLoggedIn ? const HomePage() : const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/favorite': (context) => const FavoritePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final args = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) {
              return DetailPage(restaurantId: args);
            },
          );
        }
        return null;
      },
    );
  }
}