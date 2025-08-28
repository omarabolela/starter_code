import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInScreenController extends GetxController {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;

  String? _validateEmail(String v) {
    if (v.isEmpty) return 'Email is required.';
    if (!email.text.isEmail) return 'Enter a valid email address.';
    return null;
  }

  String? _validatePassword(String v) {
    if (v.isEmpty) return 'Password cannot be empty.';
    if (v.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  void _showSnack(String title, String message) {
    if (Get.isSnackbarOpen) {
      return;
    }
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> signIn() async {
    final e = email.text.trim();
    final p = pass.text;

    final errors = <String>[];
    final emailErr = _validateEmail(e);
    final passErr = _validatePassword(p);
    if (emailErr != null) errors.add(emailErr);
    if (passErr != null) errors.add(passErr);

    if (errors.isNotEmpty) {
      FocusManager.instance.primaryFocus?.unfocus();
      _showSnack('Fix these first', errors.map((x) => '• $x').join('\n'));
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();

    loading = true;
    update();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: e,
        password: p,
      );
      // Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      _showSnack('Auth failed', e.code);
    } catch (e) {
      _showSnack('Error', e.toString());
    } finally {
      loading = false;
      update();
    }
  }

  @override
  void onClose() {
    email.dispose();
    pass.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
  }
}
