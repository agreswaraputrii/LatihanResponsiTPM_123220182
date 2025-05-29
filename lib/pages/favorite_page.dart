// lib/pages/favorite_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/pages/detail_page.dart';
import 'package:restaurant_app/utils/preferences_helper.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final PreferencesHelper _prefsHelper = PreferencesHelper();
  final ApiService _apiService = ApiService();
  List<Restaurant> _favoriteRestaurants = [];

  @override
  void initState() {
    super.initState();
    _loadFavoriteRestaurants();
  }

  Future<void> _loadFavoriteRestaurants() async {
    final prefsJsonList = await _prefsHelper.getFavoriteRestaurantIds();
    setState(() {
      _favoriteRestaurants = prefsJsonList
          .map((jsonString) => Restaurant.fromJson(json.decode(jsonString)))
          .toList();
    });
  }

  void _removeFavorite(String restaurantId) async {
    await _prefsHelper.removeFavoriteRestaurant(restaurantId);
    _loadFavoriteRestaurants();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Restaurant dihapus dari favorit.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restoran Favorit'),
      ),
      body: _favoriteRestaurants.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sentiment_dissatisfied,
                      size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 20),
                  Text(
                    'Belum ada restoran favorit.',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.grey[600]),
                  ),
                  Text(
                    'Tambahkan dari daftar restoran!',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _favoriteRestaurants.length,
              itemBuilder: (context, index) {
                final restaurant = _favoriteRestaurants[index];
                return Dismissible(
                  key: Key(restaurant.id!),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _removeFavorite(restaurant.id!);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:
                        const Icon(Icons.delete, color: Colors.white, size: 30),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(restaurantId: restaurant.id!),
                        ),
                      ).then((_) => _loadFavoriteRestaurants());
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: CachedNetworkImage(
                                imageUrl: _apiService.getRestaurantImageUrl(
                                    restaurant.pictureId!),
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Container(
                                  width: 120,
                                  height: 120,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image,
                                      size: 50, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.name ?? 'Nama Tidak Diketahui',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.deepOrange,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on,
                                          size: 18, color: Colors.grey[700]),
                                      const SizedBox(width: 4),
                                      Text(
                                        restaurant.city ??
                                            'Kota Tidak Diketahui',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          size: 18, color: Colors.amber[700]),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${restaurant.rating ?? '-'}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Colors.amber[700]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
