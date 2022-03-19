import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime dateTime;

  Order(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<Cart> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-300ff-default-rtdb.firebaseio.com/orders.json');
    try {
      final now = DateTime.now();
      final respone = await http.post(url,
          body: json.encode({
            'amount': total,
            'products': cartProducts
                .map((e) => {
                      'id': e.id,
                      'title': e.title,
                      'price': e.price,
                      'quantity': e.quantity,
                    })
                .toList(),
            'dateTime': now.toIso8601String()
          }));
      final order = Order(
          id: json.decode(respone.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: now);
      _orders.insert(0, order);
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shop-app-300ff-default-rtdb.firebaseio.com/orders.json');
    try {
      final respone = await http.get(url);
      final data = json.decode(respone.body) as Map<String, dynamic>;
      if (data.isEmpty) {
        return;
      }
      final List<Order> loadedOrders = [];
      data.forEach((orderId, value) {
        loadedOrders.add(Order(
            id: orderId,
            amount: value['amount'] as double,
            dateTime: DateTime.parse(value['dateTime']),
            products: (value['products'] as List<dynamic>)
                .map((e) => Cart(
                    id: e['id'],
                    title: e['title'],
                    quantity: e['quantity'],
                    price: e['price']))
                .toList()));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder2(
      List<Map<String, String>> cartProducts, double total) async {
    final url = Uri.parse(
        'https://shop-app-300ff-default-rtdb.firebaseio.com/orders2.json');
    try {
      final now = DateTime.now();
      final respone = await http.post(url,
          body: json.encode({
            'amount ': total,
            'products': cartProducts,
            'dateTime': now.toIso8601String()
          }));
      // final order = Order(
      //     id: json.decode(respone.body)['name'],
      //     amount: total,
      //     products: cartProducts,
      //     dateTime: now);
      // _orders.insert(0, order);
    } catch (e) {
      throw e;
    }
    //notifyListeners();
  }
}
