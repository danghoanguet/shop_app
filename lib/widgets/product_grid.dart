import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductProvider>(context);
    final product = productsData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3, // height 3 width 2
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: product.length,
        itemBuilder: (context, index) => ProductItem(
              id: product[index].id,
              imageUrl: product[index].imageUrl,
              title: product[index].title,
            ));
  }
}
