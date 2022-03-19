import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/app_draw.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Your orders')),
        drawer: AppDraw(),
        body: FutureBuilder(
          //initialData: ,
          future: Provider.of<OrderProvider>(context, listen: false)
              .fetchAndSetOrders(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (dataSnapshot.hasError) {
              //
            }
            return Consumer<OrderProvider>(
              builder: (context, orderProvider, child) => ListView.builder(
                itemBuilder: ((context, index) =>
                    OrderItem(orders: orderProvider.orders[index])),
                itemCount: orderProvider.orders.length,
              ),
            );
          },
        ));
  }
}
