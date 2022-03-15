import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String imageUrl;
  final String id;
  final String title;
  const ProductItem(
      {Key? key, required this.imageUrl, required this.id, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
          trailing: IconButton(
            color: Theme.of(context).colorScheme.secondary,
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
          title: FittedBox(
            child: Text(
              title,
              
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
