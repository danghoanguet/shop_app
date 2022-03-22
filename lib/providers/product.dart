import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  Future<void> toggleFavorite(String authToken, String userId) async {
    final url = Uri.parse(
        'https://shop-app-300ff-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$authToken');
    final bool isFav = isFavorite;
    try {
      isFavorite = !isFavorite;
      notifyListeners();
      final res = await http.put(url,
          body: json.encode({
            'isFavorite': !isFav,
          }));
      if (res.statusCode >= 400) {
        isFavorite = isFav;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = isFav;
      notifyListeners();
      throw error;
    }
  }
}
