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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
          primary: const Color(0xFF1565C0),
          onPrimary: Colors.white,
          secondary: const Color(0xFF42A5F5),
          onSecondary: Colors.white,
          surface: const Color(0xFFF0F2F5), 
          onSurface: const Color(0xFF1A1A1A),
          background: const Color(0xFFE0F2F7),
          onBackground: const Color(0xFF1A1A1A),
          error: const Color(0xFFD32F2F),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFB),
        
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, 
          elevation: 0, 
          scrolledUnderElevation: 0,
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actionsIconTheme: const IconThemeData(color: Colors.white),
        ),
        
        cardTheme: CardTheme(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.white, 
        ),
        
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 8,
            shadowColor: const Color(0xFF1565C0).withOpacity(0.3),
            backgroundColor: const Color(0xFF1565C0), 
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1565C0), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade600),
          floatingLabelStyle: const TextStyle(color: Color(0xFF1565C0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          backgroundColor: const Color(0xFF1565C0), 
        ),
        
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A1A1A),
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A1A),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF424242),
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF616161),
          ),
          bodySmall: TextStyle( 
            fontSize: 12,
            color: Color(0xFF757575),
          ),
        ),
        
        iconTheme: const IconThemeData(
          color: Color(0xFF1565C0), 
          size: 24,
        ),
        
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 8,
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