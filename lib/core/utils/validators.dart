/// Input validators for forms
class Validators {
  Validators._();

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required.';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value.trim())) return 'Enter a valid email address.';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required.';
    if (value.length < 6) return 'Password must be at least 6 characters.';
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Please confirm your password.';
    if (value != password) return 'Passwords do not match.';
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required.';
    if (value.trim().length < 2) return 'Name must be at least 2 characters.';
    return null;
  }

  static String? validatePositiveNumber(String? value, String field) {
    if (value == null || value.isEmpty) return '$field is required.';
    final num = double.tryParse(value);
    if (num == null) return 'Enter a valid number.';
    if (num <= 0) return '$field must be greater than 0.';
    return null;
  }

  static String? validateHabitName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Habit name is required.';
    if (value.trim().length > 60) return 'Name cannot exceed 60 characters.';
    return null;
  }

  static String? validateMealName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Meal name is required.';
    return null;
  }
}
