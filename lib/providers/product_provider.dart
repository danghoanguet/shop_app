import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/http_execption.dart';
import 'package:shop_app/providers/auth.dart';
import 'dart:convert';
import 'package:shop_app/providers/product.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  final String authToken;
  final String userId;

  ProductProvider(this.authToken, this._items, this.userId);

  // void updateToken(String token) => authToken = token;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="createrId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://shop-app-300ff-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final respone = await http.get(url);

      final data = json.decode(respone.body) as Map<String, dynamic>;
      print(data);
      if (data == {}) {
        print('data is empty');
        _items = [];
        notifyListeners();
        return;
      }

      url = Uri.parse(
          'https://shop-app-300ff-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResopone = await http.get(url);
      final favariteData = json.decode(favoriteResopone.body);
      final List<Product> loadedProducts = [];
      data.forEach((key, value) {
        loadedProducts.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            isFavorite: favariteData == null
                ? false
                : favariteData[key] == null
                    ? false
                    : favariteData[key]['isFavorite'] ?? false,
            price: value['price']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shop-app-300ff-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final respone = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'createrId': userId,
          }));

      final newProduct = Product(
          id: json.decode(respone.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final proIndex = _items.indexWhere((element) => element.id == id);

    final url = Uri.parse(
        'https://shop-app-300ff-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    try {
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[proIndex] = newProduct;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shop-app-300ff-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
    var exitingProductIndex = _items.indexWhere((element) => element.id == id);
    var exitingProduct = _items[exitingProductIndex];
    _items.removeAt(exitingProductIndex);
    notifyListeners();
    try {
      final respone = await http.delete(url);
      if (respone.statusCode >= 400) {
        _items.insert(exitingProductIndex, exitingProduct);
        notifyListeners();
        throw HttpException('Could not delete product!');
      }
    } catch (error) {
      throw error;
    }
  }
}
