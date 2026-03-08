
import 'package:get/get.dart';
import '../../data/models/product_model.dart';
import '../../data/services/product_service.dart';

class ProductController extends GetxController {

  final ProductService _service = ProductService();

  var isLoading = true.obs;
  var hasError = false.obs;
  var products = <Product>[].obs;
  var errorMessage = "".obs;

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
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
