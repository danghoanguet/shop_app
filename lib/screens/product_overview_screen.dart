import 'package:flutter/material.dart';
import '../widgets/product_grid.dart';

class ProductsOverViewScreen extends StatelessWidget {
  ProductsOverViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
      ),
      body: ProductGrid(),
    );
  }
}
