class AssetPaths {
  AssetPaths._(); // Private constructor - ngăn tạo instance

  // ==================== IMAGES ====================
  static const String appLogo = 'assets/images/app_logo.png';
  static const String appLogoSmall = 'assets/images/app_logo_small.png';
  static const String splashBackground = 'assets/images/splash_bg.png';
  static const String emptyStateImage = 'assets/images/empty_state.png';
  static const String errorStateImage = 'assets/images/error_state.png';
  static const String noDataImage = 'assets/images/no_data.png';
  static const String noNetworkImage = 'assets/images/no_network.png';

  // ==================== ICONS (SVG) ====================
  static const String wasteIcon = 'assets/icons/waste.svg';
  static const String binIcon = 'assets/icons/bin.svg';
  static const String truckIcon = 'assets/icons/truck.svg';
  static const String locationIcon = 'assets/icons/location.svg';
  static const String reportIcon = 'assets/icons/report.svg';
  static const String incidentIcon = 'assets/icons/incident.svg';
  static const String settingsIcon = 'assets/icons/settings.svg';
  static const String profileIcon = 'assets/icons/profile.svg';
  static const String homeIcon = 'assets/icons/home.svg';
  static const String notificationIcon = 'assets/icons/notification.svg';
  static const String mapIcon = 'assets/icons/map.svg';
  static const String phoneIcon = 'assets/icons/phone.svg';
  static const String emailIcon = 'assets/icons/email.svg';
  static const String logoutIcon = 'assets/icons/logout.svg';

  // ==================== LOTTIE ANIMATIONS ====================
  static const String loadingAnimation = 'assets/lottie/loading.json';
  static const String successAnimation = 'assets/lottie/success.json';
  static const String errorAnimation = 'assets/lottie/error.json';
  static const String emptyStateAnimation = 'assets/lottie/empty_state.json';
  static const String splashAnimation = 'assets/lottie/splash.json';

  // ==================== FONTS ====================
  /// Dùng trong pubspec.yaml:
  /// fonts:
  ///   - family: Roboto
  ///     fonts:
  ///       - asset: assets/fonts/Roboto-Regular.ttf
  ///       - asset: assets/fonts/Roboto-Bold.ttf
  ///         weight: 700
  static const String fontRoboto = 'Roboto';
  static const String fontOpenSans = 'OpenSans';
  static const String fontMontserrat = 'Montserrat';

  // ==================== SOUNDS ====================
  static const String notificationSound = 'assets/sounds/notification.mp3';
  static const String successSound = 'assets/sounds/success.mp3';
  static const String errorSound = 'assets/sounds/error.mp3';
  static const String clickSound = 'assets/sounds/click.mp3';

  // ==================== JSON DATA ====================
  static const String citiesJson = 'assets/data/cities.json';
  static const String districtsJson = 'assets/data/districts.json';
  static const String wardsJson = 'assets/data/wards.json';
}