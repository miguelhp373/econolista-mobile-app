import 'package:flutter/material.dart';

import '../../shared/themes/custom_sizes/custom_sizes.dart';
import '../../shared/widgets/signin_button_google/signin_button_google.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: kDefaultPadding * 6),
                child: Image.asset('assets/logo/brading_logo.png'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Text(
                    'Vamos Começar! \nFaça o Login',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SigninButtonGoogle(),
            ],
          ),
        ],
      ),
    );
  }
}
