
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/mello_logo.dart';
import '../widgets/mello_button.dart';
import 'sign_in_page.dart';
import 'register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              const MelloLogo(
  iconSize: 150,
),

              const SizedBox(height: 55),

              const Text(
                'Bienvenue à Mello',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: MelloColors.espresso,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Notre plateforme de coaching mental '
                'vous accompagne pour prendre soin de '
                'votre bien-être et atteindre vos objectifs.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                  color: MelloColors.cocoa,
                ),
              ),

              const Spacer(),

              MelloButton(
                text: 'Se connecter',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 15),

              MelloButton(
                text: 'Créer un compte',
                outlined: true,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 35),
            ],
          ),
        ),
      ),
    );
  }
}
