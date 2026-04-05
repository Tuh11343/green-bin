class AppHelper {

  static String formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return 'Không rõ';

    final now = DateTime.now();
    // Dùng .abs() để tránh lỗi thời gian server nhanh hơn máy khách vài giây
    final difference = now.difference(dateTime).abs();

    if (difference.inMinutes < 1) return 'Vừa xong';
    if (difference.inMinutes < 60) return '${difference.inMinutes} phút trước';
    if (difference.inHours < 24) return '${difference.inHours} giờ trước';
    if (difference.inDays < 7) return '${difference.inDays} ngày trước';

    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }



}