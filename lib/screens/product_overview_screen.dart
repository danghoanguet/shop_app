import 'package:flutter/material.dart';
import '../widgets/product_grid.dart';

enum FliterOptions {
  favorite,
  all,
}

class ProductsOverViewScreen extends StatefulWidget {
  ProductsOverViewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverViewScreen> createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {
  bool _showFavoritesOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My shop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FliterOptions selectedValue) {
              setState(() {
                if (selectedValue == FliterOptions.favorite) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            itemBuilder: ((_) => [
                  PopupMenuItem(
                    child: Text('Only Favorites'),
                    value: FliterOptions.favorite,
                  ),
                  PopupMenuItem(
                    child: Text('Show All'),
                    value: FliterOptions.all,
                  ),
                ]),
          )
        ],
      ),
      body: ProductGrid(
        showFavorites: _showFavoritesOnly,
      ),
    );
  }
}
