// lib/models/restaurant_list_response.dart
import 'package:restaurant_app/models/restaurant.dart'; // Jalur import diperbaiki

class RestaurantListResponse {
  bool? error;
  String? message;
  int? count;
  List<Restaurant>? restaurants;

  RestaurantListResponse({this.error, this.message, this.count, this.restaurants});

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      count: json['count'] as int?,
      restaurants: (json['restaurants'] as List?)
          ?.map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}