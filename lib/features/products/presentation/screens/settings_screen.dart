import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/storage/token_storage.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          // ── Profile Header ─────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF6B6B).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                      const Icon(Icons.person, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My Account',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Manage your profile & preferences',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // ── Account Section ────────────────────────────────────────
          _sectionHeader('Account'),
          _tile(
            icon: Icons.person_outline,
            label: 'Edit Profile',
            onTap: () => Get.toNamed('/profile'),
          ),
          _tile(
            icon: Icons.lock_outline,
            label: 'Change Password',
            onTap: () => Get.snackbar(
                'Coming Soon', 'Change password coming soon',
                snackPosition: SnackPosition.BOTTOM),
          ),

          const SizedBox(height: 12),

          // ── Orders Section ─────────────────────────────────────────
          _sectionHeader('Orders'),
          _tile(
            icon: Icons.receipt_long_outlined,
            label: 'My Orders',
            onTap: () {
              // Navigate to products screen and switch to Orders tab (index 2)
              Get.offAllNamed('/products');
            },
          ),
          _tile(
            icon: Icons.favorite_border,
            label: 'My Wishlist',
            onTap: () => Get.snackbar('Tip', 'Tap the ♥ tab in the bottom nav',
                snackPosition: SnackPosition.BOTTOM),
          ),
          const SizedBox(height: 12),

          // ── Support & About ────────────────────────────────────────
          _sectionHeader('Support & About'),
          _tile(
            icon: Icons.help_outline,
            label: 'Help & FAQ',
            onTap: () => Get.snackbar('Coming Soon', 'Help center coming soon',
                snackPosition: SnackPosition.BOTTOM),
          ),
          _tile(
            icon: Icons.star_outline,
            label: 'Rate the App',
            onTap: () => Get.snackbar(
                '⭐ Thank you!', 'We appreciate your support!',
                snackPosition: SnackPosition.BOTTOM),
          ),

          // ── Logout ─────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B6B),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey[500],
              letterSpacing: 1.2),
        ),
      );

  Widget _tile({
    required IconData icon,
    required String label,
    Widget? trailing,
    required VoidCallback? onTap,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6B6B).withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFFF6B6B), size: 20),
        ),
        title: Text(label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.chevron_right, color: Colors.grey)
                : null),
        onTap: onTap,
      ),
    );
  }

  void _logout() async {
    await TokenStorage.clearToken();
    Get.offAllNamed('/login');
  }
}
