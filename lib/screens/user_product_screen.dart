import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_draw.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = '/user-products';

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productProvider = Provider.of<ProductProvider>(context); // infinite loop cause when loading the FutureBuilder, use Consumer
    print('build run');
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
          child: FutureBuilder(
            future: _refreshProduct(context),
            builder: ((context, snapshot) {
              print('future build run');
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<ProductProvider>(builder: (__, value, _) {
                      print('consumer run');
                      return Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: value.items.length,
                          itemBuilder: (context, i) => Column(children: [
                            UserProductItem(
                              imageUrl: value.items[i].imageUrl,
                              title: value.items[i].title,
                              id: value.items[i].id,
                            ),
                            Divider(),
                          ]),
                        ),
                      );
                    });
            }),
          ),
        ));
  }
}
