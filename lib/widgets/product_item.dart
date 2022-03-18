import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/product_details_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    print("build run");
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () => {
            Navigator.of(context)
                .pushNamed(ProducDetailsScreen.routeName, arguments: product.id)
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            //child will not change when Product change
            builder: (context, value, Widget? _) => IconButton(
              icon: product.isFavorite
                  ? Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Icon(
                      Icons.favorite_border_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              onPressed: product.toggleFavorite,
            ),
          ),
          trailing: IconButton(
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                addItem(context, cart, product);
              }),
          title: FittedBox(
            child: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void addItem(BuildContext context, CartProvider cart, Product product) {
    cart.addItem(product.id, product.price, product.title);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added item to cart!',
          //textAlign: TextAlign.end,
        ),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
            label: 'UNDO',
            onPressed: () => cart.removeSingleItem((product.id))),
      ),
    );
  }
}
