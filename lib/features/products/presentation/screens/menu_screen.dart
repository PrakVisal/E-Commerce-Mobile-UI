import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const _menuItems = [
    "All",
    "Beauty",
    "Fashion",
    "Kids",
    "Mens",
    "Womens",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.iconTheme.color ?? theme.colorScheme.onSurface,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Menu",
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.appBarTheme.titleTextStyle?.color ??
                theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          itemCount: _menuItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final title = _menuItems[index];
            return GestureDetector(
              onTap: () {
                final controller = Get.find<ProductController>();
                controller.selectCategory(title);
                Get.back();
              },
              child: Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.headlineMedium?.color ??
                      theme.colorScheme.onSurface,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
