import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/models/product.dart';

class FakeStoreApiException implements Exception {
  final String message;
  FakeStoreApiException(this.message);

  @override
  String toString() => message;
}

/// Thin wrapper around https://fakestoreapi.com
class FakeStoreApiService {
  FakeStoreApiService._();
  static final FakeStoreApiService instance = FakeStoreApiService._();

  static const String _baseUrl = 'https://fakestoreapi.com';

  Future<List<Product>> getAllProducts() async {
    final uri = Uri.parse('$_baseUrl/products');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw FakeStoreApiException(
        'Failed to load products (${response.statusCode})',
      );
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<String>> getCategories() async {
    final uri = Uri.parse('$_baseUrl/products/categories');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw FakeStoreApiException(
        'Failed to load categories (${response.statusCode})',
      );
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => e.toString()).toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final uri = Uri.parse(
      '$_baseUrl/products/category/${Uri.encodeComponent(category)}',
    );
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw FakeStoreApiException(
        'Failed to load products for "$category" (${response.statusCode})',
      );
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Product> getProductById(int id) async {
    final uri = Uri.parse('$_baseUrl/products/$id');
    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw FakeStoreApiException(
        'Failed to load product $id (${response.statusCode})',
      );
    }
    final Map<String, dynamic> data =
        jsonDecode(response.body) as Map<String, dynamic>;
    return Product.fromJson(data);
  }
}
