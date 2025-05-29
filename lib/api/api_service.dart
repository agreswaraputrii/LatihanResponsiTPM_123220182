// lib/api/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/models/restaurant_list_response.dart'; // Jalur import diperbaiki
import 'package:restaurant_app/models/restaurant_detail_response.dart'; // Jalur import diperbaiki

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _listPath = 'list';
  static const String _detailPath = 'detail/';
  static const String _imageSmallPath = 'images/small/';

  Future<RestaurantListResponse> getListRestaurants() async {
    final response = await http.get(Uri.parse(_baseUrl + _listPath));
    if (response.statusCode == 200) {
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load list of restaurants');
    }
  }

  Future<RestaurantDetailResponse> getDetailRestaurant(String id) async {
    final response = await http.get(Uri.parse(_baseUrl + _detailPath + id));
    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  String getRestaurantImageUrl(String pictureId) {
    return _baseUrl + _imageSmallPath + pictureId;
  }
}