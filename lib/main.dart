import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_details_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          create: (_) => ProductProvider('', [], ''),
          update: (context, auth, ProductProvider? previous) => ProductProvider(
              auth.token, previous == null ? [] : previous.items, auth.userId),
          // update: (context, auth, prevProducts) =>
          //     prevProducts!..updateToken(auth.token),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProxyProvider<Auth, OrderProvider>(
          create: (_) => OrderProvider('', [], ''),
          // update: (context, auth, previous) =>
          //     previous!..updateToken(auth.token)
          update: (context, auth, previous) => OrderProvider(
              auth.token, previous == null ? [] : previous.orders, auth.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'MyShop',
              theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme:
                    ColorScheme.fromSwatch(primarySwatch: Colors.purple)
                        .copyWith(secondary: Colors.deepOrange),
              ),
              home: auth.isAuth
                  ? ProductsOverViewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          // we dont need to check authResultSnapshot.data here since
                          // our future auth.tryAutoLogin() will trigger ther
                          //build method again in the end and then we enter anyway
                          // because auth.isAuth is true cause we have store token
                          //in device local storage
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                      // : authResultSnapshot.data == false ? AuthScreen() : ProductsOverViewScreen(), redundant
                    ),
              routes: {
                ProducDetailsScreen.routeName: (context) =>
                    ProducDetailsScreen(),
                CartScreen.routeName: (context) => CartScreen(),
                OrderScreen.routeName: (context) => OrderScreen(),
                UserProductScreen.routeName: (context) => UserProductScreen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
              },
            )),
      ),
    );
  }
}
