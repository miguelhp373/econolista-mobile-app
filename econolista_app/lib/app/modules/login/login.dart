import 'package:flutter/material.dart';

import '../../shared/auth/auth_user_controller/auth_user_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthUserController = AuthUserController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Login Google'),
          onPressed: () => isAuthUserController.signInWithGoogle(),
        ),
      ),
    );
  }
}
