import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  static const String _darkModeKey = 'settings_dark_mode';
  static const String _fontScaleKey = 'settings_font_scale';

  final isDarkMode = false.obs;
  final fontScale = 1.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();

    // Persist settings automatically when they change
    ever(isDarkMode, (_) => _saveSettings());
    ever(fontScale, (_) => _saveSettings());
  }

  void toggleDarkMode(bool enabled) {
    isDarkMode.value = enabled;
  }

  void setFontScale(double value) {
    fontScale.value = value.clamp(0.8, 1.4);
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      isDarkMode.value = prefs.getBool(_darkModeKey) ?? false;
      fontScale.value = prefs.getDouble(_fontScaleKey) ?? 1.0;
    } catch (e) {
      print('❌ Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_darkModeKey, isDarkMode.value);
      await prefs.setDouble(_fontScaleKey, fontScale.value);
    } catch (e) {
      print('❌ Error saving settings: $e');
    }
  }
}
