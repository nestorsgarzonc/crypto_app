abstract interface class TextValidators {
  static final emailValidator = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static final passwordValidator = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  static final nameValidator = RegExp(r'^[a-zA-Z ]{2,}$');
  static final phoneValidator = RegExp(r'^[0-9]{10}$');

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!emailValidator.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value, {bool optional = false}) {
    final isEmptyOrNull = value == null || value.isEmpty;
    if (isEmptyOrNull && !optional) {
      return 'Password is required';
    }
    if ((value?.length ?? 0) < 8 && !isEmptyOrNull) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? password, {bool optional = false}) {
    final isEmptyOrNull = value == null || value.isEmpty || password == null || password.isEmpty;
    if (isEmptyOrNull && !optional) {
      return 'Confirm password is required';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (!nameValidator.hasMatch(value)) {
      return 'Enter a valid name';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!phoneValidator.hasMatch(value)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  static String? birthday(DateTime? value) {
    if (value == null) {
      return 'Birthday is required';
    }
    final now = DateTime.now();
    if (now.difference(value).inDays < 6570) {
      return 'You must be 18 years old';
    }
    return null;
  }

  static String? date(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }
    return null;
  }

  static String? number(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number is required';
    }
    if (int.tryParse(value) == null) {
      return 'Enter a valid number';
    }
    return null;
  }
}
