class CropsModel {
  final String name;
  final String image;
  final String description;
  final String category;
  final String price;
  final String quantity;


  CropsModel({
    required this.name,
    required this.image,
    required this.description,
    required this.category,
    required this.price,
    required this.quantity,
  });

  factory CropsModel.fromJson(Map<String, dynamic> json) {
    return CropsModel(
      name: json['name'],
      image: json['image'],
      description: json['description'],
      category: json['category'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}