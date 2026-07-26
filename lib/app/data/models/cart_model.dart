class CartItem {
  String id;
  final String name;
  final int price;
  final String imageUrl;
  final String rating;
  final String category;
  String productId;
  int quantity;
  bool isSelected;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.rating = '0.0',
    this.category = '',
    this.productId = '',
    this.quantity = 1,
    this.isSelected = true,
  });

  /// Konversi ke Map untuk dikirim ke backend
  Map<String, dynamic> toJson() {
    return {
      'productId': productId.isNotEmpty ? productId : id,
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'image': imageUrl,
      'quantity': quantity,
      'isSelected': isSelected,
    };
  }

  /// Buat dari Map backend
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['productId']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? 0,
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
      quantity: json['quantity'] ?? 1,
      isSelected: json['isSelected'] ?? true,
    );
  }
}
