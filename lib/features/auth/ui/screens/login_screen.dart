import 'package:crypto_app/core/input_formatter/input_formatters.dart';
import 'package:crypto_app/core/validators/text_validators.dart';
import 'package:crypto_app/features/auth/ui/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const route = '/onboarding';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Welcome to Crypto App',
                style: theme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: TextValidators.email,
                controller: _emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [InputFormatters.emailFormatter],
                autofillHints: const [AutofillHints.email],
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: TextValidators.password,
                controller: _passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text('Login'),
                icon: const Icon(Icons.login),
              ),
              TextButton.icon(
                onPressed: () => GoRouter.of(context).pushNamed(RegisterScreen.route),
                label: const Text('Register'),
                icon: const Icon(Icons.person_add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
