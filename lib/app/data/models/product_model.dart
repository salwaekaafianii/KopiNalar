class ProductModel {
  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final String description;
  final String image;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.description,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'],
      name: json['name'],
      category: json['category'],
      price: json['price'],
      rating: (json['rating'] as num).toDouble(),
      description: json['description'],
      image: json['image'],
    );
  }
}