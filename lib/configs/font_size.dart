/// Nguyên tắc:
/// - Display  : tiêu đề lớn, hero text, số liệu nổi bật
/// - Headline : tiêu đề màn hình, section header
/// - Title    : tiêu đề card, dialog, app bar
/// - Body     : nội dung đọc chính
/// - Label    : nút bấm, chip, tab, caption
abstract final class AppFontSize {
  // ─── Display ─────────────────────────────────────────────
  // Dùng cho hero text, số liệu lớn, splash screen
  static const double displayLarge  = 57.0; // Rất hiếm dùng
  static const double displayMedium = 45.0;
  static const double displaySmall  = 36.0;

  // ─── Headline ────────────────────────────────────────────
  // Dùng cho tiêu đề màn hình, section header lớn
  static const double headlineLarge  = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall  = 24.0;

  // ─── Title ───────────────────────────────────────────────
  // Dùng cho app bar, tiêu đề card, dialog title
  static const double titleLarge  = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall  = 14.0;

  // ─── Body ────────────────────────────────────────────────
  // Dùng cho nội dung văn bản chính, mô tả, paragraph
  static const double bodyLarge  = 16.0; // Nội dung chính
  static const double bodyMedium = 14.0; // Nội dung phụ (mặc định)
  static const double bodySmall  = 12.0; // Ghi chú nhỏ

  // ─── Label ───────────────────────────────────────────────
  // Dùng cho button, chip, tab bar, badge, input hint
  static const double labelLarge  = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall  = 11.0;
}