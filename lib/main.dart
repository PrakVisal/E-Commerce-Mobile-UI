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
import 'features/products/presentation/screens/menu_screen.dart';
import 'features/products/presentation/screens/product_detail_screen.dart';
import 'features/products/presentation/screens/place_order_screen.dart';
import 'features/products/presentation/screens/wishlist_screen.dart';

import 'features/products/presentation/controllers/cart_controller.dart';
import 'features/settings/presentation/controllers/settings_controller.dart';

void main() {
  Get.put(CartController());
  Get.put(SettingsController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(
      () {
        final isDarkMode = settings.isDarkMode.value;
        final textScale = settings.fontScale.value;

        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1F1F1F),
            dividerColor: Colors.white24,
            disabledColor: Colors.white60,
            textTheme: ThemeData.dark().textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF121212),
              iconTheme: const IconThemeData(color: Colors.white),
              titleTextStyle: ThemeData.dark()
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          builder: (context, child) {
            return MediaQuery(
              // ignore: deprecated_member_use
              data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
              child: child!,
            );
          },
          initialRoute: "/products",
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
              name: "/menu",
              page: () => const MenuScreen(),
            ),
            GetPage(
              name: "/trending",
              page: () => const TrendingProductsScreen(),
            ),
            GetPage(
              name: "/wishlist",
              page: () => const WishlistScreen(),
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
      },
    );
  }
}

