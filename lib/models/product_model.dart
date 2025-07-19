class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.isFavorite = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Safely extract first image URL from 'images' array
    final image =
        (json['images'] != null &&
                json['images'] is List &&
                json['images'].isNotEmpty)
            ? json['images'][0]['src']
            : '';

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      imageUrl: image,
    );
  }
}
