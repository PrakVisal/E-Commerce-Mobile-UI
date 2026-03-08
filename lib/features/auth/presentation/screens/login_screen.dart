import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool hidePassword = true.obs;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6366F1),
              Color(0xFF8B5CF6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),

            child: Container(
              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Icon(
                    Icons.lock_outline,
                    size: 60,
                    color: Color(0xFF6366F1),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Login to continue",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// Email Field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Password Field
                  Obx(() => TextField(
                    controller: passwordController,
                    obscureText: hidePassword.value,

                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: const Icon(Icons.lock_outline),

                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          hidePassword.value = !hidePassword.value;
                        },
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  )),

                  const SizedBox(height: 28),

                  /// Login Button
                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                          controller.login(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          );
                        },

                        child: controller.isLoading.value
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}