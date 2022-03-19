import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_draw.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    Future<void> _refreshProduct(BuildContext context) async {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchAndSetProducts();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDraw(),
      body: RefreshIndicator(
        onRefresh: () {
          return _refreshProduct(context);
        },
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productProvider.items.length,
            itemBuilder: (context, i) => Column(children: [
              UserProductItem(
                imageUrl: productProvider.items[i].imageUrl,
                title: productProvider.items[i].title,
                id: productProvider.items[i].id,
              ),
              Divider(),
            ]),
          ),
        ),
      ),
    );
  }
}
