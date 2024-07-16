import 'package:crypto_app/core/extension_method/date_extension.dart';
import 'package:crypto_app/core/extension_method/object_extension.dart';
import 'package:crypto_app/core/input_formatter/input_formatters.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/core/validators/text_validators.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:crypto_app/features/auth/provider/auth_provider.dart';
import 'package:crypto_app/ui/padding.dart';
import 'package:crypto_app/ui/snackbars.dart';
import 'package:crypto_app/ui/spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileTab extends ConsumerStatefulWidget {
  const ProfileTab({super.key});

  @override
  ConsumerState<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends ConsumerState<ProfileTab> {
  static const days18Years = Duration(days: 18 * 365);
  static final currentDate = DateTime.now();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isInitialized = false;
  DateTime? pickedDate;
  bool get _isLessThan18 =>
      pickedDate?.let((it) => it.isAfter(currentDate.subtract(days18Years))) ?? false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(authProvider.notifier).getUser());
    super.initState();
  }

  void setFields(UserModel user) {
    if (isInitialized) return;
    isInitialized = true;
    _nameController.text = user.name;
    _idController.text = user.id.toString();
    _birthdayController.text = user.birthday.toFormattedString();
    pickedDate = user.birthday;
    if (mounted) setState(() {});
  }

  void _onUpdateUser(_, StateAsync state) {
    switch (state) {
      case AsyncInitial() || AsyncLoadingC():
        break;
      case AsyncDone():
        Snackbars.showSuccess(context, 'Profile updated successfully');
      case AsyncFailure():
        Snackbars.showError(context, 'Error updating profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<StateAsync>(authProvider.select((e) => e.updateUser), _onUpdateUser);
    final (userModel, updateUserLoading) =
        ref.watch(authProvider.select((e) => (e.userModel, e.updateUser.isLoading)));
    final theme = Theme.of(context);
    return userModel.when(
      data: (user) {
        WidgetsBinding.instance.addPostFrameCallback((_) => setFields(user));
        return Form(
          key: _formKey,
          child: ListView(
            padding: Paddings.bodySafePadding(context),
            children: [
              Text('Profile', style: theme.textTheme.titleLarge),
              const Text('You can edit your profile here.'),
              Spacings.v16,
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _passwordController,
                textInputAction: TextInputAction.next,
                obscureText: true,
                autofillHints: const [AutofillHints.newPassword],
                keyboardType: TextInputType.visiblePassword,
                validator: (v) => TextValidators.password(v, optional: true),
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
                    TextValidators.confirmPassword(value, _passwordController.text, optional: true),
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
              Spacings.v16,
              ElevatedButton(
                onPressed: updateUserLoading ? null : () => _onUpdate(user),
                child: updateUserLoading
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Update'),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator.adaptive()),
      error: (e) => Center(child: Text('Error: $e')),
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

  void _onUpdate(UserModel user) {
    if (_formKey.currentState?.validate() != true) return;
    ref.read(authProvider.notifier).updateUser(
          UpdateUser.fromUserModel(
            user.copyWith(
              name: _nameController.text,
              id: int.tryParse(_idController.text),
              birthday: pickedDate,
            ),
            _passwordController.text.isNotEmpty ? _passwordController.text : null,
          ),
        );
  }
}
