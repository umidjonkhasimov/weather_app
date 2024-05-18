import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/authentication/auth_repository/auth_status.dart';
import 'package:weather_app/authentication/auth_repository/firebase_auth_repository.dart';
import 'package:weather_app/authentication/pages/welcome_page.dart';
import 'package:weather_app/home/home_page.dart';

import 'authentication/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (context) => AuthBloc(repository: FirebaseAuthRepository()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _key = GlobalKey();

  NavigatorState get _navigatorState => _key.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _key,
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      builder: (context, child) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            switch (state.authStatus) {
              case AuthenticationStatus.unknown:
                const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              case AuthenticationStatus.authenticated:
                _navigatorState.pushAndRemoveUntil(
                  HomePage.route(),
                  (route) => false,
                );
              case AuthenticationStatus.unAuthenticated:
                if (state.exception == null) {
                  _navigatorState.pushAndRemoveUntil(
                    WelcomePage.route(),
                    (route) => false,
                  );
                }
            }
          },
          child: child,
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff03045e)),
        useMaterial3: true,
      ),
    );
  }
}
