import 'package:econolista_app/app/shared/auth/auth_user_controller/auth_user_controller.dart';
import 'package:econolista_app/app/shared/routes/routes.dart';
import 'package:econolista_app/app/shared/custom_theme/custom_theme.dart';
import 'package:flutter/material.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme.copyWith(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Color(0xFF333333),
            fontFamily: 'Capriola',
          ), // Cor de Texto Principal
          bodyMedium: TextStyle(
            color: Color(0xFF666666),
            fontFamily: 'Capriola',
          ), // Cor de Texto Secundária
        ),
      ),
      home: AuthUserController().handleAuthState(),
      //initialRoute: '/splash',
      routes: applicationRoutes,
    );
  }
}
