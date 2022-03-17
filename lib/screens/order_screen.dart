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
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your orders')),
      drawer: AppDraw(),
      body: ListView.builder(
        itemBuilder: ((context, index) =>
            OrderItem(orders: orderProvider.orders[index])),
        itemCount: orderProvider.orders.length,
      ),
    );
  }
}
