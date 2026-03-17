import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../controllers/auth_controller.dart';
import '../../data/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _ctrl = Get.put(ProfileController());
  final AuthController _authCtrl = Get.put(AuthController());

  final _usernameCtrl = TextEditingController();
  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    // Populate fields from already-loaded user (if available)
    if (_ctrl.user.value != null) {
      _populateFields(_ctrl.user.value);
    }
    // Also listen for future loads (e.g., first load or refresh)
    ever<User?>(_ctrl.user, _populateFields);
    // Always kick off a fresh fetch to get latest data
    _ctrl.fetchProfile();
  }

  void _populateFields(User? u) {
    if (u == null) return;
    _usernameCtrl.text = u.username ?? '';
    _fullNameCtrl.text = u.fullName ?? '';
    _emailCtrl.text = u.email;
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text('My Profile',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        actions: [
          if (!_editing)
            TextButton.icon(
              onPressed: () => setState(() => _editing = true),
              icon: const Icon(Icons.edit_outlined,
                  color: Color(0xFFFF6B6B), size: 18),
              label: const Text('Edit',
                  style: TextStyle(
                      color: Color(0xFFFF6B6B), fontWeight: FontWeight.w600)),
            )
          else
            TextButton(
              onPressed: () => setState(() {
                _editing = false;
                _populateFields(_ctrl.user.value);
              }),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value && _ctrl.user.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFFF6B6B)),
          );
        }
        if (_ctrl.errorMessage.value.isNotEmpty && _ctrl.user.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(_ctrl.errorMessage.value,
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _ctrl.fetchProfile,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6B6B)),
                  child: const Text('Retry',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Avatar ─────────────────────────────────────────────
              _buildAvatar(),
              const SizedBox(height: 28),

              // ── Form Card ──────────────────────────────────────────
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Personal Information',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    _field('Username', _usernameCtrl,
                        icon: Icons.alternate_email_rounded),
                    const SizedBox(height: 14),
                    _field('Full Name', _fullNameCtrl,
                        icon: Icons.person_outline),
                    const SizedBox(height: 14),
                    _field('Email', _emailCtrl,
                        icon: Icons.email_outlined, enabled: false),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Save Button (only in edit mode) ────────────────────
              if (_editing)
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _ctrl.isLoading.value ? null : _save,
                        icon: _ctrl.isLoading.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.save_rounded),
                        label: Text(_ctrl.isLoading.value
                            ? 'Saving...'
                            : 'Save Changes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),

              if (!_editing) const SizedBox(height: 0),
              const SizedBox(height: 24),

              // ── Logout ─────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _authCtrl.logout,
                  icon: const Icon(Icons.logout,
                      color: Colors.redAccent, size: 18),
                  label: const Text('Log Out',
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAvatar() {
    final u = _ctrl.user.value;
    final initials = _getInitials(u);
    return Center(
      child: Stack(
        children: [
          Container(
            width: 96,
            height: 96,
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
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (u?.username != null || u?.email != null)
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_rounded,
                    color: Color(0xFFFF6B6B), size: 18),
              ),
            ),
        ],
      ),
    );
  }

  String _getInitials(User? u) {
    if (u == null) return '?';
    final name = u.fullName ?? u.username ?? u.email;
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _card({required Widget child}) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: child,
      );

  Widget _field(String label, TextEditingController ctrl,
      {required IconData icon, bool enabled = true}) {
    return TextField(
      controller: ctrl,
      enabled: _editing && enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon,
            size: 20,
            color: _editing && enabled
                ? const Color(0xFFFF6B6B)
                : Colors.grey[400]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFF0F0F0)),
        ),
        filled: !(_editing && enabled),
        fillColor: Colors.grey[50],
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  void _save() {
    final current = _ctrl.user.value;
    if (current == null) return;

    final updated = User(
      id: current.id,
      email: current.email, // can't change email
      username: _usernameCtrl.text.trim().isNotEmpty
          ? _usernameCtrl.text.trim()
          : current.username,
      fullName: _fullNameCtrl.text.trim().isNotEmpty
          ? _fullNameCtrl.text.trim()
          : current.fullName,
    );

    _ctrl.updateProfile(updated).then((_) {
      if (mounted) setState(() => _editing = false);
    });
  }
}
