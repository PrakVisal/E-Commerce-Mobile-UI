import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  const Text(
                    'Stylish',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5460),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.skipToLogin,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PageView
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [
                  _buildSplashPage(
                    context,
                    title: 'Choose Products',
                    description:
                        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
                    icon: Icons.shopping_bag_rounded,
                  ),
                  _buildSplashPage(
                    context,
                    title: 'Make Payment',
                    description:
                        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
                    icon: Icons.payment_rounded,
                  ),
                  _buildSplashPage(
                    context,
                    title: 'Get Your Order',
                    description:
                        'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit.',
                    icon: Icons.local_shipping_rounded,
                  ),
                ],
              ),
            ),
            // Bottom Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  // Slide indicators
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        3,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: controller.currentPageIndex.value == index
                              ? 24
                              : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: controller.currentPageIndex.value == index
                                ? const Color(0xFFFF5460)
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Navigation Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => GestureDetector(
                          onTap: controller.currentPageIndex.value > 0
                              ? controller.previousPage
                              : null,
                          child: Text(
                            'Prev',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: controller.currentPageIndex.value > 0
                                  ? Colors.grey[800]
                                  : Colors.grey[300],
                            ),
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          '${controller.currentPageIndex.value + 1}/3',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Obx(
                        () => controller.currentPageIndex.value == 2
                            ? GestureDetector(
                                onTap: controller.skipToLogin,
                                child: const Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFF5460),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: controller.nextPage,
                                child: const Text(
                                  'Next',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFF5460),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplashPage(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                icon,
                size: 120,
                color: const Color(0xFFFF5460),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
