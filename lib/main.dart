import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/products/presentation/screens/products_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      initialRoute: "/login",

      getPages: [

        GetPage(
          name: "/login",
          page: () => LoginScreen(),
        ),

        GetPage(
          name: "/products",
          page: () => ProductsScreen(),
        ),
      ],
    );
  }
}