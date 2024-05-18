import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/authentication/bloc/auth_bloc.dart';
import 'package:weather_app/authentication/pages/sign_in_page.dart';
import 'package:weather_app/authentication/pages/sign_up_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  static MaterialPageRoute<WelcomePage> route() => MaterialPageRoute(
        builder: (context) => const WelcomePage(),
      );

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 56,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    SignInPage.route(),
                  ),
                  child: const Text('Sign in'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 56,
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).push(
                    SignUpPage.route(),
                  ),
                  child: const Text('Sign up'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
