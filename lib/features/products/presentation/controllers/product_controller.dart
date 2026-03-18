import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';
import '../../data/services/product_service.dart';
import '../../../../core/storage/token_storage.dart';

class ProductController extends GetxController {
  final ProductService _service = ProductService();

  var isLoading = true.obs;
  var isTrendingLoading = true.obs;
  var hasError = false.obs;
  var products = <Product>[].obs;
  var trendingProducts = <Product>[].obs;
  var discountedProducts = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isDiscountLoading = true.obs;
  var errorMessage = "".obs;

  var selectedCategory = "All".obs;
  var selectedSort = "Popular".obs;
  var searchQuery = "".obs;

  bool get isFiltering =>
      searchQuery.value.isNotEmpty ||
      selectedCategory.value != "All" ||
      selectedSort.value != "Popular";

  final RxList<CategoryModel> categories = <CategoryModel>[
    CategoryModel(value: "All", name: "All", iconData: Icons.category)
  ].obs;

  final sortOptions = [
    "Popular",
    "Price: Low to High",
    "Price: High to Low",
    "Newest"
  ];

  @override
  void onInit() {
    _buildCategories();
    fetchProducts();
    fetchTrendingProducts();
    fetchDiscountedProducts();
    super.onInit();
  }

  void _buildCategories() {
    categories.value = [
      CategoryModel(value: "All", name: "All", iconData: Icons.category),
      ...ProductCategory.productCategories(),
    ];
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      String? sortPrice;
      String? sortCreatedAt;

      switch (selectedSort.value) {
        case "Price: Low to High":
          sortPrice = "asc";
          break;
        case "Price: High to Low":
          sortPrice = "desc";
          break;
        case "Newest":
          sortCreatedAt = "desc";
          break;
      }

      final result = await _service.fetchProducts(
        category: selectedCategory.value,
        name: searchQuery.value,
        sortPrice: sortPrice,
        sortCreatedAt: sortCreatedAt,
      );
      products.assignAll(result);

      applyFilters();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      print('Product fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTrendingProducts() async {
    try {
      isTrendingLoading.value = true;
      final result = await _service.fetchProducts(trending: true);
      trendingProducts.assignAll(result);
    } catch (e) {
      print('Trending fetch error: $e');
    } finally {
      isTrendingLoading.value = false;
    }
  }

  Future<void> fetchDiscountedProducts() async {
    try {
      isDiscountLoading.value = true;
      final result = await _service.fetchProducts(onPromotion: true);
      discountedProducts.assignAll(result);
    } catch (e) {
      print('Discount fetch error: $e');
    } finally {
      isDiscountLoading.value = false;
    }
  }

  void applyFilters() {
    // Backend already handles filtering and sorting, but we can keep local filtering for instant search results if needed.
    // However, the task says to "use the getall endpoint properly", which implies relying on backend.
    // For now, let's keep it simple and assignall from the fetch result.
    filteredProducts.assignAll(products);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    fetchProducts(); // Re-fetch from backend for search
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    fetchProducts(); // Re-fetch from backend for category
  }

  void selectSort(String sort) {
    selectedSort.value = sort;
    fetchProducts(); // Re-fetch from backend for sort
  }

  List<Product> getFeaturedProducts() => discountedProducts.toList();

  List<Product> getTrending() => trendingProducts.take(3).toList();

  /// Returns the full list of trending products, used by the dedicated
  /// trending page when the user taps "View all".
  List<Product> getAllTrendingProducts() => trendingProducts.toList();

  List<Product> getNewArrivals() => products.take(4).toList();

  Future<void> logout() async {
    await TokenStorage.clearToken();
    Get.offAllNamed("/login");
  }
}
