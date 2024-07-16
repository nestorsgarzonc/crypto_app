import 'package:crypto_app/core/extension_method/date_extension.dart';
import 'package:crypto_app/core/extension_method/object_extension.dart';
import 'package:crypto_app/core/input_formatter/input_formatters.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/core/validators/text_validators.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:crypto_app/features/auth/provider/auth_provider.dart';
import 'package:crypto_app/features/dashboard/ui/screens/dashboard_screen.dart';
import 'package:crypto_app/ui/modals.dart';
import 'package:crypto_app/ui/snackbars.dart';
import 'package:crypto_app/ui/spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  static const route = '/register';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  static const days18Years = Duration(days: 18 * 365);
  static final currentDate = DateTime.now();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? pickedDate;
  bool get _isLessThan18 =>
      pickedDate?.let((it) => it.isAfter(currentDate.subtract(days18Years))) ?? false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    ref.listen<StateAsync>(authProvider.select((e) => e.registerState), _listener);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: isKeyboardVisible
          ? null
          : SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: _onRegister,
                child: const Text('Register'),
              ),
            ),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Complete the form below to register', style: theme.titleMedium),
              Spacings.v16,
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [InputFormatters.emailFormatter],
                autofillHints: const [AutofillHints.email],
                validator: TextValidators.email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              Spacings.v16,
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                keyboardType: TextInputType.visiblePassword,
                validator: TextValidators.password,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              Spacings.v16,
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _confirmPasswordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                keyboardType: TextInputType.visiblePassword,
                validator: (value) =>
                    TextValidators.confirmPassword(value, _passwordController.text),
                decoration: const InputDecoration(labelText: 'Confirm Password'),
              ),
              Spacings.v16,
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _nameController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                inputFormatters: [InputFormatters.nameFormatter],
                autofillHints: const [AutofillHints.name, AutofillHints.givenName],
                validator: TextValidators.name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              Spacings.v16,
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _idController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: TextValidators.number,
                decoration: const InputDecoration(labelText: 'ID Number'),
              ),
              Spacings.v16,
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _birthdayController,
                readOnly: true,
                onTap: _selectDate,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.datetime,
                validator: (_) => _isLessThan18 ? 'You must be 18 years old' : null,
                decoration: const InputDecoration(labelText: 'Birthday'),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        Snackbars.showSuccess(context, 'User registered successfully');
        GoRouter.of(context).goNamed(DashboardScreen.route);
    }
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() != true) return;
    ref.read(authProvider.notifier).register(
          RegisterModel(
            email: _emailController.text,
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            name: _nameController.text,
            id: int.parse(_idController.text),
            birthday: pickedDate!,
          ),
        );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: pickedDate ?? currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );
    if (picked == null) return;
    _birthdayController.text = picked.toFormattedString();
    pickedDate = picked;
    setState(() {});
  }
}
