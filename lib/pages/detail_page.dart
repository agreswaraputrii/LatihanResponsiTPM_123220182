// lib/pages/detail_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant_app/api/api_service.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/models/restaurant_detail_response.dart';
import 'package:restaurant_app/utils/preferences_helper.dart';

class DetailPage extends StatefulWidget {
  final String restaurantId;

  const DetailPage({super.key, required this.restaurantId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiService _apiService = ApiService();
  final PreferencesHelper _prefsHelper = PreferencesHelper();
  late Future<RestaurantDetailResponse> _restaurantDetailFuture;
  bool _isFavorite = false;
  Restaurant? _restaurant;

  @override
  void initState() {
    super.initState();
    _restaurantDetailFuture = _apiService.getDetailRestaurant(widget.restaurantId);
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final status = await _prefsHelper.isRestaurantFavorite(widget.restaurantId);
    setState(() {
      _isFavorite = status;
    });
  }

  void _toggleFavorite() async {
    if (_restaurant == null) return;

    if (_isFavorite) {
      await _prefsHelper.removeFavoriteRestaurant(widget.restaurantId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restaurant dihapus dari favorit.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      await _prefsHelper.addFavoriteRestaurant(_restaurant!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Restaurant ditambahkan ke favorit.'),
          backgroundColor: Colors.green,
        ),
      );
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Restoran'),
      ),
      body: FutureBuilder<RestaurantDetailResponse>(
        future: _restaurantDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}\nMohon Cek Koneksi Internet Anda.'));
          } else if (snapshot.hasData) {
            _restaurant = snapshot.data!.restaurant;
            if (_restaurant == null) {
              return const Center(child: Text('Detail restoran tidak ditemukan.'));
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Restoran
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), // Sudut lebih membulat
                    child: CachedNetworkImage(
                      imageUrl: _apiService.getRestaurantImageUrl(_restaurant!.pictureId!),
                      width: double.infinity,
                      height: 250, // Tinggi gambar lebih besar
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nama Restoran & Tombol Favorit
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _restaurant!.name ?? 'Nama Tidak Diketahui',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.grey,
                          size: 35, // Ukuran ikon favorit lebih besar
                        ),
                        onPressed: _toggleFavorite,
                        tooltip: _isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Lokasi dan Rating
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 22, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${_restaurant!.city ?? 'Tidak Diketahui'} - ${_restaurant!.address ?? 'Tidak Diketahui'}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 22, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        'Rating: ${_restaurant!.rating ?? '-'}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.amber[700]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi
                  Text(
                    'Deskripsi:',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _restaurant!.description ?? 'Deskripsi tidak tersedia.',
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),

                  // Contoh Menus (jika API detail menyediakan)
                  // Perlu perbaikan model Restaurant jika ingin menampilkan ini
                  // Text('Menu Makanan:', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  // ... (Logika untuk menampilkan menu)
                ],
              ),
            );
          }
          return const Center(child: Text('Tidak ada data'));
        },
      ),
    );
  }
}