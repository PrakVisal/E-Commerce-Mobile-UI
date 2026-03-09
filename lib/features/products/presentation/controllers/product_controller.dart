
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/services/product_service.dart';
import '../../../../core/storage/token_storage.dart';

class ProductController extends GetxController {

  final ProductService _service = ProductService();

  var isLoading = true.obs;
  var hasError = false.obs;
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var errorMessage = "".obs;
  
  var selectedCategory = "All".obs;
  var selectedSort = "Popular".obs;
  var searchQuery = "".obs;

  final categories = ["All", "Beauty", "Fashion", "Kids", "Mens", "Womens"];
  final sortOptions = ["Popular", "Price: Low to High", "Price: High to Low", "Newest"];

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final result = await _service.fetchProducts();
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

  void applyFilters() {
    List<Product> filtered = products;

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // Filter by category
    if (selectedCategory.value != "All") {
      filtered = filtered
          .where((p) =>
              p.category?.toLowerCase() == selectedCategory.value.toLowerCase())
          .toList();
    }

    // Apply sorting
    switch (selectedSort.value) {
      case "Price: Low to High":
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case "Price: High to Low":
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case "Newest":
        filtered.sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
        break;
      case "Popular":
      default:
        // Keep original order from backend
        break;
    }

    filteredProducts.assignAll(filtered);
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void selectSort(String sort) {
    selectedSort.value = sort;
    applyFilters();
  }

  List<Product> getFeaturedProducts() =>
      filteredProducts.where((p) => p.onPromotion).toList().take(6).toList();

  List<Product> getTrendingProducts() =>
      filteredProducts.take(3).toList();

  List<Product> getNewArrivals() =>
      products.take(4).toList();

  Future<void> logout() async {
    await TokenStorage.clearToken();
    Get.offAllNamed("/login");
  }
}


