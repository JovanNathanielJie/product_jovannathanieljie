import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product_model.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> getAllProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil data!');
      }
      final List<dynamic> jsonData = jsonDecode(response.body);
      List<Product> products = jsonData.map((json) {
        return Product(
          id: json['id'],
          title: json['title'],
          price: (json['price'] as num).toDouble(),
          category: json['category'],
          image: json['image'],
          rating: Rating(
            rate: (json['rating']['rate'] as num).toDouble(),
            count: json['rating']['count'],
          ),
        );
      }).toList();
      return products;
    } catch (e) {
      rethrow;
    }
  }
}

