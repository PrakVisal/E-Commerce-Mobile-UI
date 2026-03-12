import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/auth/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/auth/presentation/screens/forgot_password_screen.dart';
import 'features/auth/presentation/screens/get_started_screen.dart';
import 'features/products/presentation/screens/products_screen.dart';
import 'features/products/presentation/screens/trending_products_screen.dart';
import 'features/auth/presentation/screens/profile_screen.dart';
import 'features/products/presentation/screens/product_detail_screen.dart';
import 'features/products/presentation/screens/place_order_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash",
      getPages: [
        GetPage(
          name: "/splash",
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: "/login",
          page: () => const LoginScreen(),
        ),
        GetPage(
          name: "/signup",
          page: () => const SignupScreen(),
        ),
        GetPage(
          name: "/forgot-password",
          page: () => const ForgotPasswordScreen(),
        ),
        GetPage(
          name: "/get-started",
          page: () => const GetStartedScreen(),
        ),
        GetPage(
          name: "/products",
          page: () => ProductsScreen(),
        ),
        GetPage(
          name: "/trending",
          page: () => const TrendingProductsScreen(),
        ),
        GetPage(
          name: "/profile",
          page: () => const ProfileScreen(),
        ),
        GetPage(
          name: "/product-detail",
          page: () => ProductDetailScreen(product: Get.arguments),
        ),
        GetPage(
          name: "/place-order",
          page: () => const PlaceOrderScreen(),
        ),
      ],
    );
  }
}
