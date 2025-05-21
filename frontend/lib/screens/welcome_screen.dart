import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_status_bar.dart';
import '../widgets/primary_button.dart';
import 'create_account_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const CustomStatusBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 158,
                      height: 155,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                    const SizedBox(height: 23),
                    Text(
                      'Eggxpress',
                      style: AppTheme.titleStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Beautiful eCommerce UI Kit for your online store',
                        style: AppTheme.subtitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 106),
                    PrimaryButton(
                      text: "Let's get started",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateAccountScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'I already have an account',
                          style: AppTheme.linkTextStyle,
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primaryColor,
                          ),
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 55),
                    Container(
                      width: 134,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(34),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}