// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/models/restaurant_list_response.dart';
import 'package:restaurant_app/pages/detail_page.dart';
import 'package:restaurant_app/pages/favorite_page.dart';
import 'package:restaurant_app/pages/login_page.dart';
import 'package:restaurant_app/utils/preferences_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _prefsHelper = PreferencesHelper();
  late Future<RestaurantListResponse> _restaurantListFuture;
  String _username = 'Pengguna';

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _restaurantListFuture = _apiService.getListRestaurants();
  }

  Future<void> _loadUsername() async {
    final username = await _prefsHelper.getUsername();
    if (username != null) {
      setState(() {
        _username = username;
      });
    }
  }

  void _logout() async {
    await _prefsHelper.clearUserData();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hai, $_username!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Restoran Favorit',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: FutureBuilder<RestaurantListResponse>(
        future: _restaurantListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error: ${snapshot.error}\nMohon Cek Koneksi Internet Anda.'));
          } else if (snapshot.hasData) {
            final restaurants = snapshot.data!.restaurants;
            if (restaurants == null || restaurants.isEmpty) {
              return const Center(child: Text('Tidak ada restoran ditemukan.'));
            }
            return ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPage(restaurantId: restaurant.id!),
                      ),
                    );
                  },
                  child: Card(
                    // Card Theme sudah diatur di main.dart, jadi cukup gunakan Card()
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(
                          12.0), // Padding lebih proporsional
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align item ke atas
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10.0), // Sudut gambar membulat
                            child: CachedNetworkImage(
                              imageUrl: _apiService
                                  .getRestaurantImageUrl(restaurant.pictureId!),
                              width: 120, // Lebar gambar sedikit lebih besar
                              height: 120, // Tinggi gambar sedikit lebih besar
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
                                        color: const Color.fromARGB(255, 0, 0,
                                            0), // Warna nama restoran
                                      ),
                                  maxLines: 1, // Membatasi satu baris
                                  overflow: TextOverflow
                                      .ellipsis, // Tambahkan ellipsis jika terlalu panjang
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 18, color: Colors.grey[700]),
                                    const SizedBox(width: 4),
                                    Text(
                                      restaurant.city ?? 'Kota Tidak Diketahui',
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
                                          ?.copyWith(color: Colors.amber[700]),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Menambahkan deskripsi singkat untuk preview
                                Text(
                                  restaurant.description ??
                                      'Deskripsi tidak tersedia.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Tidak ada data'));
        },
      ),
    );
  }
}
