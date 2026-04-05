class RegexPatterns {
  RegexPatterns._();

  // ==================== NUMBERS ====================
  static const String onlyNumbers = r'^[0-9]+$';
  static const String positiveInteger = r'^[1-9][0-9]*$';
  static const String decimal = r'^[0-9]+(\.[0-9]{1,2})?$';

  // ==================== LETTERS ====================
  static const String onlyLetters = r'^[a-zA-Z\s]+$';
  static const String onlyLettersLowercase = r'^[a-z\s]+$';
  static const String onlyLettersUppercase = r'^[A-Z\s]+$';

  // ==================== ALPHANUMERIC ====================
  static const String alphanumeric = r'^[a-zA-Z0-9]+$';
  static const String alphanumericWithSpace = r'^[a-zA-Z0-9\s]+$';
  static const String noSpecialChars = r'^[a-zA-Z0-9\s]+$';

  // ==================== EMAIL ====================
  static const String email =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // ==================== PHONE ====================
  // Số điện thoại quốc tế (10-15 chữ số)
  static const String phoneInternational = r'^[+]?[0-9]{10,15}$';
  // Số điện thoại Việt Nam
  static const String phoneVietnam = r'^(\+84|0)[0-9]{9,10}$';
  // Số điện thoại Việt Nam không +84
  static const String phoneVietnamShort = r'^0[0-9]{9,10}$';

  // ==================== URL ====================
  static const String url =
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$';

  // ==================== SPECIAL PATTERNS ====================
  static const String passwordStrong =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  static const String username = r'^[a-zA-Z0-9_]{3,20}$';
  static const String ipAddress =
      r'^(\d{1,3}\.){3}\d{1,3}$';
  static const String hexColor = r'^#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$';
}