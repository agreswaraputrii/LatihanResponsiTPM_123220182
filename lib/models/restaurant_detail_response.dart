// lib/models/restaurant_detail_response.dart
import 'package:restaurant_app/models/restaurant.dart'; // Jalur import diperbaiki

class RestaurantDetailResponse {
  bool? error;
  String? message;
  Restaurant? restaurant;

  RestaurantDetailResponse({this.error, this.message, this.restaurant});

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      restaurant: json['restaurant'] != null
          ? Restaurant.fromJson(json['restaurant'] as Map<String, dynamic>)
          : null,
    );
  }
}
