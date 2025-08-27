import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:map_exam/login_screen_controller.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LogInScreenController>(
      init: LogInScreenController(),
      builder: (viewmodel) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Please sign in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: viewmodel.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      decoration: const InputDecoration(
                        hintText: 'type your email here',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: viewmodel.pass,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => viewmodel.loading ? null : viewmodel.signIn(),
                      autofillHints: const [AutofillHints.password],
                      decoration: const InputDecoration(
                        hintText: 'type your password',
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: 140,
                      child: ElevatedButton(
                        onPressed: viewmodel.loading ? null : viewmodel.signIn,
                        child: Text(viewmodel.loading ? 'Signing in…' : 'Sign in'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
