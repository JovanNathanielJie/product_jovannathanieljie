class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });
}

class Product {
  final int id;
  final String title;
  final double price;
  final String category;
  final String image;
  final Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.image,
    required this.rating,
  });


  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      image: json['image'] ?? '',
      rating: Rating(
        rate: (json['rating']['rate'] ?? 0 as num).toDouble(),
        count: json['rating']['count'] ?? 0,
      ),
    );
  }

  bool get isExpensive => price > 50;

  String getShortTitle() {
    if (title.length > 35) {
      return title.substring(0, 35) + "...";
    }
    return title;
  }
}