
import 'package:greenbin/configs/regex_pattern.dart';

class ValidationConstants {
  ValidationConstants._(); // Private constructor

  // ==================== PASSWORD ====================
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 50;
  static const String passwordRegex = RegexPatterns.passwordStrong;
  static const String passwordHint =
      'Tối thiểu 8 ký tự, chứa chữ hoa, chữ thường, số và ký tự đặc biệt';

  // ==================== NAME ====================
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const String nameRegex = RegexPatterns.onlyLetters;

  // ==================== EMAIL ====================
  static const String emailRegex = RegexPatterns.email;

  // ==================== PHONE ====================
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  static const String phoneRegex = RegexPatterns.phoneVietnam;
  static const String phoneRegexShort = RegexPatterns.phoneVietnamShort;

  // ==================== USERNAME ====================
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const String usernameRegex = RegexPatterns.username;

  // ==================== ADDRESS ====================
  static const int minAddressLength = 5;
  static const int maxAddressLength = 200;

  // ==================== DESCRIPTION ====================
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 500;

  // ==================== REPORT ====================
  static const int minReportDescriptionLength = 20;
  static const int maxReportDescriptionLength = 1000;

  // ==================== ERROR MESSAGES ====================
  static const String emptyFieldError = 'Trường này không được để trống';
  static const String invalidEmailError = 'Email không hợp lệ';
  static const String invalidPhoneError = 'Số điện thoại không hợp lệ';
  static const String passwordTooShortError =
      'Mật khẩu phải có ít nhất $minPasswordLength ký tự';
  static const String passwordTooLongError =
      'Mật khẩu không được vượt quá $maxPasswordLength ký tự';
  static const String passwordWeakError =
      'Mật khẩu quá yếu. $passwordHint';
  static const String nameInvalidError = 'Tên chỉ được chứa chữ cái và khoảng trắng';
  static const String usernameTakenError = 'Username này đã được sử dụng';
  static const String passwordMismatchError = 'Mật khẩu không khớp';
  static const String minLengthError = 'Tối thiểu {length} ký tự';
  static const String maxLengthError = 'Tối đa {length} ký tự';
}