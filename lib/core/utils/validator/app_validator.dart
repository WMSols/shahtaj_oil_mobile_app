import 'package:shahtaj_oil_mobile_app/core/design/texts/app_texts.dart';
import 'package:shahtaj_oil_mobile_app/core/utils/helper/app_helper.dart';

class AppValidator {
  AppValidator._();

  static final RegExp _emailPattern = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return AppTexts.emailRequired;
    if (!_emailPattern.hasMatch(email)) return AppTexts.emailInvalid;
    return null;
  }

  static String? validatePassword(String? value) {
    if (AppHelper.isNullOrEmpty(value)) return AppTexts.passwordRequired;
    final s = value!;
    if (s.length < 8) return AppTexts.passwordMinLength;
    if (s.contains(' ')) return AppTexts.passwordNoSpaces;
    return null;
  }

  static String? validatePasswordLogin(String? value) {
    if (AppHelper.isNullOrEmpty(value)) return AppTexts.passwordRequired;
    return null;
  }

  static String? validateConfirmPassword(String? value, String otherPassword) {
    final passwordError = validatePassword(value);
    if (passwordError != null) return passwordError;
    if ((value ?? '') != otherPassword) return AppTexts.passwordsDoNotMatch;
    return null;
  }

  static String? validatePhone(String? value) {
    if (AppHelper.isNullOrEmpty(value)) return AppTexts.phoneRequired;
    final cleaned = value!.trim().replaceAll(RegExp(r'[\s\-\(\)\+]'), '');
    if (!RegExp(r'^\d+$').hasMatch(cleaned)) {
      return AppTexts.phoneInvalid;
    }
    if (cleaned.length < 7 || cleaned.length > 15) {
      return AppTexts.phoneLength;
    }
    return null;
  }

  static String? validatePakistanLocalPhone(String? value) {
    if (AppHelper.isNullOrEmpty(value)) return AppTexts.phoneRequired;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) return AppTexts.obPhoneLength;
    if (!digits.startsWith('3')) return AppTexts.phoneInvalid;
    return null;
  }

  static String? validatePakistanCnic(String? value) {
    if (AppHelper.isNullOrEmpty(value)) return AppTexts.fieldRequired;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 13) return AppTexts.cnicInvalid;
    return null;
  }

  static String? validateRequired(String? value, [String? fieldName]) {
    if (AppHelper.isNullOrEmpty(value)) {
      return fieldName != null
          ? '$fieldName is required'
          : AppTexts.fieldRequired;
    }
    return null;
  }

  static String? validateAmount(String? value) {
    if (AppHelper.isNullOrEmpty(value)) return AppTexts.fieldRequired;
    final parsed = double.tryParse(value!.replaceAll(',', '').trim());
    if (parsed == null || parsed < 0) return AppTexts.amountInvalid;
    return null;
  }

  static String? validatePercentage(String? value) {
    if (AppHelper.isNullOrEmpty(value)) return AppTexts.fieldRequired;
    final parsed = double.tryParse(value!.trim());
    if (parsed == null || parsed < 0 || parsed > 100) {
      return AppTexts.percentageInvalid;
    }
    return null;
  }
}
