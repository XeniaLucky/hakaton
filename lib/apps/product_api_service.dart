import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/product.dart';

class ProductApiService {
  Future<List<Product>> fetchProductDetails() async {
    final response =
    await http.get(Uri.parse('YOUR_PRODUCT_API_ENDPOINT'));

    if (response.statusCode == 200) {
      List<dynamic> values = jsonDecode(response.body);
      List<Product> products = [];
      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            products.add(Product.fromJson(map));
          }
        }
      }
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}
