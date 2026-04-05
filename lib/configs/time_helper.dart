import 'package:timeago/timeago.dart' as timeago;

class TimeHelper {
  static String format(DateTime dateTime) {
    // Đăng ký ngôn ngữ tiếng Việt (chỉ cần gọi 1 lần trong cả vòng đời app)
    timeago.setLocaleMessages('vi', timeago.ViMessages());

    // Trả về chuỗi thời gian tương đối
    return timeago.format(dateTime, locale: 'vi');
  }
}