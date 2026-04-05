import 'package:greenbin/models/report.dart';

import '../models/point_transaction.dart';
import '../models/reward.dart';
import '../models/user.dart';
import 'enums.dart';

class MockData {
  // 6 phần thưởng tối thiểu
  static final List<Reward> rewards = [
    const Reward(
      id: 1,
      name: "Túi vải Canvas GreenBin",
      description: "Túi vải canvas tự nhiên, thân thiện với môi trường, thiết kế riêng bởi GreenBin.",
      stockQuantity: 50,
      point: 100,
      imageUrl: "https://picsum.photos/id/225/400/400",
    ),
    const Reward(
      id: 2,
      name: "Bình nước giữ nhiệt Inox",
      description: "Dung tích 500ml, giữ nóng 8h và giữ lạnh lên đến 12h.",
      stockQuantity: 15,
      point: 350,
      imageUrl: "https://picsum.photos/id/160/400/400",
    ),
    const Reward(
      id: 3,
      name: "Bộ ống hút thủy tinh",
      description: "Gồm 2 ống hút thẳng, 1 ống hút cong và 1 cọ rửa chuyên dụng.",
      stockQuantity: 100,
      point: 50,
      imageUrl: "https://picsum.photos/id/429/400/400",
    ),
    const Reward(
      id: 4,
      name: "Sổ tay giấy tái chế",
      description: "Sổ tay khổ A5, 100 trang làm hoàn toàn từ bột giấy tái chế.",
      stockQuantity: 30,
      point: 80,
      imageUrl: "https://picsum.photos/id/367/400/400",
    ),
    const Reward(
      id: 5,
      name: "Voucher HighLands 50k",
      description: "Mã giảm giá trực tiếp 50.000 VNĐ áp dụng cho toàn hệ thống Highlands Coffee.",
      stockQuantity: 10,
      point: 500,
      imageUrl: "https://picsum.photos/id/431/400/400",
    ),
    const Reward(
      id: 6,
      name: "Pin sạc dự phòng 10.000mAh",
      description: "Hỗ trợ sạc nhanh, vỏ làm từ nhựa tái sinh cao cấp.",
      stockQuantity: 5,
      point: 1200,
      imageUrl: "https://picsum.photos/id/20/400/400",
    ),
  ];

  // 4 giao dịch điểm (thêm 2 cái mới)
  static final List<PointTransaction> transactions = [
    PointTransaction(
      id: 101,
      userId: 1,
      rewardId: 1,
      rewardName: "Túi vải Canvas GreenBin",
      amount: 100,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    PointTransaction(
      id: 102,
      userId: 1,
      rewardId: 3,
      rewardName: "Bộ ống hút thủy tinh",
      amount: 50,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    ),
    // 2 giao dịch mới thêm
    PointTransaction(
      id: 103,
      userId: 1,
      rewardId: 2,
      rewardName: "Bình nước giữ nhiệt Inox",
      amount: 350,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    PointTransaction(
      id: 104,
      userId: 1,
      rewardId: 5,
      rewardName: "Voucher HighLands 50k",
      amount: 500,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  ];

  static const User user = User(
    id: 1,
    name: "Nguyễn Văn Green",
    email: "greenbin@example.com",
    points: 6500, // Cập nhật lại số điểm cho phù hợp sau khi trừ giao dịch
    imageUrl: "https://i.pravatar.cc/150?u=1",
    isSocialLogin: true,
  );



  static final List<Report> reports = [
    Report(
      id: 1,
      userId: 1,
      binId: 101,
      latitude: 10.7769,
      longitude: 106.6869,
      addressName: "Công viên Tao Đàn, Q1, TPHCM",
      description: "Thùng rác tại góc công viên bị tràn đầy, cần dọn dẹp ngay",
      status: ReportStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    ),
    Report(
      id: 2,
      userId: 1,
      binId: 102,
      latitude: 10.7751,
      longitude: 106.6850,
      addressName: "Đường Nguyễn Huệ, Q1, TPHCM",
      description: "Rác thải nằm dưới đất gây bẩn, cần vệ sinh lại khu vực",
      status: ReportStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 45)),
    ),
    Report(
      id: 3,
      userId: 1,
      binId: 103,
      latitude: 10.7905,
      longitude: 106.6949,
      addressName: "Phố đi bộ Nguyễn Huệ, Q1, TPHCM",
      description: "Thùng rác nắp bị hỏng, rác tràn ra khắp nơi",
      status: ReportStatus.processing,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 7, minutes: 15)),
    ),
    Report(
      id: 4,
      userId: 1,
      binId: 104,
      latitude: 10.7870,
      longitude: 106.7016,
      addressName: "Lotte Mart Q1, TPHCM",
      description: "Xung quanh khu vực thương mại bị nhiều rác thải, ảnh hưởng cảnh quan",
      status: ReportStatus.processing,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 22)),
    ),
    Report(
      id: 5,
      userId: 1,
      binId: 105,
      latitude: 10.7742,
      longitude: 106.6923,
      addressName: "Công viên 23/9, Q1, TPHCM",
      description: "Thùng rác quá nhỏ so với lượng rác sinh ra hàng ngày",
      status: ReportStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

}