import 'package:get/get.dart';
import '../../../auth/data/auth_service.dart';
import '../../../../core/storage/token_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;

      final token = await _authService.login(email, password);

      await TokenStorage.saveToken(token);

      isLoggedIn.value = true;

      Get.offAllNamed("/products");
    } catch (e) {
      Get.snackbar(
        "Login Failed",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      isLoading.value = true;

      final token = await _authService.signup(email, password);

      await TokenStorage.saveToken(token);

      isLoggedIn.value = true;

      Get.offAllNamed("/products");
    } catch (e) {
      Get.snackbar(
        "Signup Failed",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      isLoading.value = true;

      await _authService.forgotPassword(email);

      Get.snackbar(
        "Success",
        "Password reset email sent. Check your inbox.",
        duration: const Duration(seconds: 3),
      );

      Get.offAllNamed("/login");
    } catch (e) {
      Get.snackbar(
        "Failed",
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await TokenStorage.clearToken();

    isLoggedIn.value = false;

    Get.offAllNamed("/login");
  }
}
