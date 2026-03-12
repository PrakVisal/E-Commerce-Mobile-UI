import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';
import '../../data/models/user_model.dart';
import '../controllers/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());
  final authController = Get.put(AuthController());

  // form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final countryController = TextEditingController();
  final bankAccountController = TextEditingController();
  final accountHolderController = TextEditingController();
  final ifscController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // when user data arrives populate controllers
    ever<User?>(controller.user, (u) {
      if (u != null) {
        emailController.text = u.email;
        pincodeController.text = u.pincode ?? '';
        addressController.text = u.address ?? '';
        cityController.text = u.city ?? '';
        stateController.text = u.state ?? '';
        countryController.text = u.country ?? '';
        bankAccountController.text = u.bankAccountNumber ?? '';
        accountHolderController.text = u.accountHolderName ?? '';
        ifscController.text = u.ifscCode ?? '';
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    pincodeController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    bankAccountController.dispose();
    accountHolderController.dispose();
    ifscController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text('Error: ${controller.errorMessage.value}'),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatarSection(),
              const SizedBox(height: 24),
              const Text('Personal Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField(emailController, 'Email Address', enabled: false),
              const SizedBox(height: 12),
              _buildTextField(passwordController, 'Password', obscure: true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // navigate to change password screen if exists
                  },
                  child: const Text('Change Password'),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Business Address Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField(pincodeController, 'Pincode'),
              const SizedBox(height: 12),
              _buildTextField(addressController, 'Address'),
              const SizedBox(height: 12),
              _buildTextField(cityController, 'City'),
              const SizedBox(height: 12),
              _buildTextField(stateController, 'State'),
              const SizedBox(height: 12),
              _buildTextField(countryController, 'Country'),
              const SizedBox(height: 24),
              const Text('Bank Account Details',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField(bankAccountController, 'Bank Account Number'),
              const SizedBox(height: 12),
              _buildTextField(accountHolderController, "Account Holder's Name"),
              const SizedBox(height: 12),
              _buildTextField(ifscController, 'IFSC Code'),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  child: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    backgroundColor: const Color(0xFFFF6B6B),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    // use the auth controller to perform logout
                    authController.logout();
                  },
                  child: const Text('Logout',
                      style: TextStyle(color: Colors.red)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAvatarSection() {
    // This is a placeholder avatar. You could load a real image if user
    // profile includes one.
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, size: 48, color: Colors.white),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // handle avatar change
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.edit, size: 16, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool obscure = false, bool enabled = true}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  void _saveProfile() {
    final current = controller.user.value;
    if (current == null) return;

    final updated = User(
      id: current.id,
      email: emailController.text,
      fullName: current.fullName,
      pincode: pincodeController.text,
      address: addressController.text,
      city: cityController.text,
      state: stateController.text,
      country: countryController.text,
      bankAccountNumber: bankAccountController.text,
      accountHolderName: accountHolderController.text,
      ifscCode: ifscController.text,
    );

    controller.updateProfile(updated);
  }
}
