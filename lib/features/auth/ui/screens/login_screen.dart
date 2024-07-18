import 'package:crypto_app/core/input_formatter/input_formatters.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/core/validators/text_validators.dart';
import 'package:crypto_app/features/auth/provider/auth_provider.dart';
import 'package:crypto_app/features/auth/ui/screens/register_screen.dart';
import 'package:crypto_app/features/dashboard/ui/screens/dashboard_screen.dart';
import 'package:crypto_app/ui/modals.dart';
import 'package:crypto_app/ui/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  static const route = '/onboarding';

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _listener(_, StateAsync state) {
    switch (state) {
      case AsyncInitial():
        break;
      case AsyncLoadingC():
        Modals.showLoading(context);
      case AsyncFailure(error: final f):
        Modals.removeDialog(context);
        Snackbars.showError(context, f.message);
      case AsyncDone():
        Modals.removeDialog(context);
        Snackbars.showSuccess(context, 'Login successful');
        GoRouter.of(context).goNamed(DashboardScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    ref.listen<StateAsync>(authProvider.select((e) => e.registerState), _listener);
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
                key: const Key('emailField'),
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
                key: const Key('passwordField'),
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
                key: const Key('loginButton'),
                onPressed: _onLogin,
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

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).login(_emailController.text, _passwordController.text);
  }
}
