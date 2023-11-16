import 'package:flutter/material.dart';

import '../../auth/auth_user_controller/auth_user_controller.dart';
import '../../themes/custom_sizes/custom_sizes.dart';

class SigninButtonGoogle extends StatelessWidget {
  const SigninButtonGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    final isAuthUserController = AuthUserController();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: kDefaultPadding * 2),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: kDefaultButtonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        kDefaultborderRadiusOfButtons,
                      ),
                    ),
                  ),
                  onPressed: () => isAuthUserController.signInWithGoogle(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 28,
                        width: 28,
                        child: Image.asset(
                          'assets/icons/google_icon.png',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.only(right: 40),
                        child: Text(
                          'Fazer Login Com Google',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: kDefaultButtonFontSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const SizedBox(
                child: Text(
                  '©miguelhp',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
