import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key, required this.orders}) : super(key: key);

  final Order orders;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 800,
      ),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    ));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.orders.amount}'),
          subtitle: Text(
            DateFormat('dd/MM/yyyy - hh:mm').format(widget.orders.dateTime),
          ),
          trailing: IconButton(
            icon: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onPressed: () {
              setState(() {
                !_isExpanded ? _controller.forward() : _controller.reverse();
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ),
        //if (_isExpanded)
        AnimatedContainer(
          duration: Duration(milliseconds: 600),
          curve: Curves.fastOutSlowIn,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          //height: min(widget.orders.products.length * 20 + 40, 100),
          constraints: BoxConstraints(
            maxHeight:
                _isExpanded ? widget.orders.products.length * 20 + 40 : 0,
          ),
          child: ListView(
              children: widget.orders.products
                  .map((e) => FadeTransition(
                        opacity: _opacityAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${e.quantity}x\t\t\t\t\$${e.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),
                      ))
                  .toList()),
        )
      ]),
    );
  }
}
