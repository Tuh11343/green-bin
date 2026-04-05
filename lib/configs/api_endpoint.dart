class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'http://192.168.1.194:5000';
  static const int timeOut = 10;

  // ==================== AUTH ENDPOINTS ====================
  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String logout = '/api/v1/auth/logout';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String changePassword = '/api/v1/auth/change-password';
  static const String verifyOtp = '/api/v1/auth/verify-otp';
  static const String resendOtp = '/api/v1/auth/resend-otp';
  static const String googleSignIn = '/api/v1/auth/googleSignIn';

  // ==================== REWARD ENDPOINTS ====================
  static const String getAllRewards = '/api/v1/rewards';
  static const String redeemReward = '/api/v1/rewards/redeem';

  // ==================== REPORT ENDPOINTS ====================
  static const String getAllReports='/api/v1/reports';
  static const String createReport='/api/v1/reports/me';
  static const String getUserRecentReports='/api/v1/reports/me';
  static const String getUserReportsPaginated='/api/v1/reports/me/paginated';
  static const String adminUpdateUserReport='/api/v1/reports/updateUserReport';

  // ==================== POINT TRANSACTION ENDPOINTS ====================
  static const String getUserPointTransactions = '/api/v1/pointTransactions/me';

  // ==================== USER ENDPOINTS ====================
  static const String getUserById = '/api/v1/users';
  static const String getCurrentUser='/api/v1/users/me';
  static const String getAllUsers='/api/v1/users';
  static const String updateUserProfile='/api/v1/users/update-me';

  // ==================== COLLECTION TASK ENDPOINTS ====================
  static const String submitTask = '/api/v1/collectionTask/submitTask';
  static const String getAllCollectionTasks='/api/v1/collectionTask';

  // ==================== COLLECTOR STAT ENDPOINTS ====================
  static const String getCollectorStat='/api/v1/collectorStat';

  // ==================== INCIDENT ====================
  static const String submitIncident = 'api/v1/incident';

  // ==================== NOTIFICATION ENDPOINTS ====================
  static const String getAllNotifications='/api/v1/notifications/me';
  static const String markAsRead='/api/v1/notifications/me/read';
  static const String markAllAsRead='/api/v1/notifications/me/readAll';
  static const String deleteUserNotificationById='/api/v1/notifications/me/delete';
  static const String deleteUserNotifications='/api/v1/notifications/me/all';

  // ==================== BIN ENDPOINTS ====================
  static const String getAllBins='/api/v1/bins';
  static const String getUnCollectedBin='/api/v1/bin/unCollected';

  // ==================== SEARCH & FILTER ====================
  static const String searchBins = '/api/v1/waste-bins/search';
  static const String searchReports = '/api/v1/reports/search';
  static const String searchIncidents = '/api/v1/incidents/search';

  // ==================== EXPORT & DOWNLOAD ====================
  static const String exportReports = '/api/v1/reports/export';
  static const String exportStatistics = '/api/v1/statistics/export';


  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';

  static const String nominatimSearch = '$nominatimBaseUrl/search';
  static const String nominatimReverse = '$nominatimBaseUrl/reverse';


}
