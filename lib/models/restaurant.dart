class Restaurant {
  String? id;
  String? name;
  String? description;
  String? pictureId;
  String? city;
  String? address; // <-- TAMBAHKAN PROPERTI INI
  double? rating;

  Restaurant({
    this.id,
    this.name,
    this.description,
    this.pictureId,
    this.city,
    this.address, // <-- TAMBAHKAN DI SINI
    this.rating,
  });

  // Constructor untuk konversi dari JSON
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      pictureId: json['pictureId'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?, // <-- TAMBAHKAN PEMROSESAN JSON INI
      rating: (json['rating'] as num?)?.toDouble(),
    );
  }

  // Method untuk konversi ke JSON (berguna untuk menyimpan favorit jika detail disimpan)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'pictureId': pictureId,
      'city': city,
      'address': address, // <-- TAMBAHKAN DI SINI
      'rating': rating,
    };
  }
}