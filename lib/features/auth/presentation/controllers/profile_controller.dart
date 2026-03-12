import 'package:get/get.dart';

import '../../data/auth_service.dart';
import '../../data/models/user_model.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  var user = Rxn<User>();
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      user.value = await _authService.getProfile();
    } catch (e) {
      errorMessage.value = e.toString();
      print('ProfileController.fetchProfile error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(User updated) async {
    try {
      isLoading.value = true;
      await _authService.updateProfile(updated);
      // refresh local copy
      user.value = updated;
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Update Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
