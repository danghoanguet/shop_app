import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductGrid({Key? key, required this.showFavorites}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductProvider>(context, listen: true);
    final product =
        showFavorites ? productsProvider.favoriteItems : productsProvider.items;

    Future<void> _refreshProduct(BuildContext context) async {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchAndSetProducts();
    }

    //final testProducts = context.read<ProductProvider>().items;
    return RefreshIndicator(
      onRefresh: (() {
        return _refreshProduct(context);
      }),
      child: GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3, // height 3 width 2
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: product.length,
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
                value: product[index],
                // create: (context) => product[index],
                child: ProductItem(),
              )),
    );
  }
}
