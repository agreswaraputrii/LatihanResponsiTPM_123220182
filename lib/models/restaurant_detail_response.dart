import 'package:restaurant_app/models/restaurant.dart'; 

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
