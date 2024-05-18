import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../auth_repository/widgets/text_field.dart';
import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static MaterialPageRoute<SignInPage> route() => MaterialPageRoute(
        builder: (context) => const SignInPage(),
      );

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBLoc = context.read<AuthBloc>();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.exception != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              // TODO
              content: Text(''),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign in'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                textField(
                  controller: _emailController,
                  hint: 'Enter your email',
                  label: 'Email',
                ),
                const SizedBox(height: 16),
                textField(
                  controller: _passwordController,
                  hint: 'Enter your password',
                  label: 'Password',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return FilledButton(
                        onPressed: () {
                          authBLoc.add(
                            AuthEventSignIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                        },
                        child: state.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white),
                              )
                            : const Text('Sign in'),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
