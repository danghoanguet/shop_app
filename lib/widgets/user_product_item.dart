import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem(
      {Key? key, required this.title, required this.imageUrl, required this.id})
      : super(key: key);

  final String title;
  final String imageUrl;
  final String id;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        softWrap: true,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Row(
          children: [
            Spacer(),
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            IconButton(
              onPressed: () {
                Provider.of<ProductProvider>(context, listen: false)
                    .deleteProduct(id);
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
