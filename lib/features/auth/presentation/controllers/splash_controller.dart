import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final currentPageIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void nextPage() {
    if (currentPageIndex.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPageIndex.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToLogin() {
    Get.offNamed('/login');
  }

  void onPageChanged(int index) {
    currentPageIndex.value = index;
  }
}
