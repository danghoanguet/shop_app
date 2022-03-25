import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screens/product_details_screen.dart';

import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final scaffold = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
          onTap: () => {
            Navigator.of(context)
                .pushNamed(ProducDetailsScreen.routeName, arguments: product.id)
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
              //child will not change when Product change
              builder: (context, prod, _) {
            return IconButton(
              icon: prod.isFavorite
                  ? Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  : Icon(
                      Icons.favorite_border_outlined,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              onPressed: () async {
                try {
                  await prod.toggleFavorite(auth.token, auth.userId);
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        !prod.isFavorite
                            ? 'Remove from favorite list'
                            : 'Add to favorite list',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } catch (e) {
                  print(e.toString());
                }
              },
            );
          }),
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
