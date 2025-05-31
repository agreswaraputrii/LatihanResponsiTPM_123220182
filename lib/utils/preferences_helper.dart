import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_app/models/restaurant.dart';

class PreferencesHelper {
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _loggedInStatusKey = 'isLoggedIn'; 
  static const String _loggedInUserKey = 'loggedInUser'; 
  static const String _favoriteRestaurantsKey = 'favoriteRestaurants';

  Future<void> saveUserData(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_passwordKey, password);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  Future<String?> getPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  Future<void> setLoggedInStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInStatusKey, status);
  }

  Future<bool> getLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInStatusKey) ?? false;
  }

  Future<void> setLoggedInUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loggedInUserKey, username);
  }

  Future<String?> getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_loggedInUserKey);
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
    await prefs.remove(_loggedInStatusKey); 
    await prefs.remove(_loggedInUserKey); 
    await prefs.remove(_favoriteRestaurantsKey); 
  }

  Future<List<String>> getFavoriteRestaurantIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteRestaurantsKey) ?? [];
  }

  Future<void> addFavoriteRestaurant(Restaurant restaurant) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoritesJson = prefs.getStringList(_favoriteRestaurantsKey) ?? [];
    List<Restaurant> favorites = favoritesJson.map((jsonString) => Restaurant.fromJson(json.decode(jsonString))).toList();

    if (!favorites.any((fav) => fav.id == restaurant.id)) {
      favorites.add(restaurant);
      List<String> updatedFavoritesJson = favorites.map((fav) => json.encode(fav.toJson())).toList();
      await prefs.setStringList(_favoriteRestaurantsKey, updatedFavoritesJson);
    }
  }

  Future<void> removeFavoriteRestaurant(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoritesJson = prefs.getStringList(_favoriteRestaurantsKey) ?? [];
    List<Restaurant> favorites = favoritesJson.map((jsonString) => Restaurant.fromJson(json.decode(jsonString))).toList();

    favorites.removeWhere((fav) => fav.id == restaurantId);
    List<String> updatedFavoritesJson = favorites.map((fav) => json.encode(fav.toJson())).toList();
    await prefs.setStringList(_favoriteRestaurantsKey, updatedFavoritesJson);
  }

  Future<bool> isRestaurantFavorite(String restaurantId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoritesJson = prefs.getStringList(_favoriteRestaurantsKey) ?? [];
    List<Restaurant> favorites = favoritesJson.map((jsonString) => Restaurant.fromJson(json.decode(jsonString))).toList();
    return favorites.any((fav) => fav.id == restaurantId);
  }
}