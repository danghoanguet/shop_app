import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';

import '../providers/cart_provider.dart';

class PlaceOrder extends StatelessWidget {
  const PlaceOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    final cartProviderValue = cartProvider.items.values.toList();

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: cartProviderValue.isEmpty
            ? Center(
                child: Text(
                  'You don\'t have any orders yet!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              )
            : Column(
                children: [
                  Text(
                    'Your orders',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: ((_, index) => Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  leading: Container(
                                    height: 50,
                                    width: 50,
                                    child: CircleAvatar(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: FittedBox(
                                              fit: BoxFit.contain,
                                              child: Text(
                                                '\$${cartProviderValue[index].price}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        )),
                                  ),
                                  title: Text(
                                    cartProviderValue[index].title,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Total: \$${(cartProviderValue[index].price * cartProviderValue[index].quantity)}'),
                                  trailing: Text(
                                      '${cartProviderValue[index].quantity} x'),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  orderProvider.addOrder(cartProviderValue,
                                      cartProvider.totalAmount);
                                  cartProvider.clearCartById(
                                      cartProvider.items.keys.toList()[index]);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary),
                                ),
                                child: Text(
                                  'Order this item',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          )),
                      itemCount: cartProvider.itemCount,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      orderProvider.addOrder(
                          cartProviderValue, cartProvider.totalAmount);
                      cartProvider.clearAllCart();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                    ),
                    child: Text(
                      'Order all',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
