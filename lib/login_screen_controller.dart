import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogInScreenController extends GetxController {
  final email = TextEditingController();
  final pass = TextEditingController();
  bool loading = false;

  Future<void> signIn() async {
    loading = true;
    update();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: pass.text,
      );
      // Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      // as mentioned in Task B1, ii. no need for validation
      // Get.snackbar('Auth failed', e.code, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
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
