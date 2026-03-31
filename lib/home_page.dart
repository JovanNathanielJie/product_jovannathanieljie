import 'package:flutter/material.dart';
import 'api_service.dart';
import 'product_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();
  late Future<List<Product>> _products;
  bool _isFiltering = false;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _products = _apiService.getAllProducts();
    _products.then((products) {
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
      });
    });
  }

  void _toggleFilter() {
    setState(() {
      _isFiltering = !_isFiltering;
      if (_isFiltering) {
        _filteredProducts = _allProducts
            .where((product) => product.category.toLowerCase() == 'electronics')
            .toList();
      } else {
        _filteredProducts = _allProducts;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(_isFiltering ? Icons.filter_list : Icons.filter_list_off),
            onPressed: _toggleFilter,
            tooltip: _isFiltering ? 'Show All' : 'Filter Electronics',
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _products,
        builder: (context, snapshot) {
          // Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error State
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          List<Product> displayedProducts = _isFiltering
              ? _filteredProducts
              : (_allProducts.isEmpty ? snapshot.data ?? [] : _allProducts);

          if (displayedProducts.isEmpty) {
            return Center(
              child: Text('No products found'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: displayedProducts.length,
            itemBuilder: (context, index) {
              final product = displayedProducts[index];
              return _buildProductCard(product);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.getShortTitle(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: product.isExpensive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color:
                          product.isExpensive ? Colors.red : Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        '${product.rating.rate}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '(${product.rating.count} reviews)',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
