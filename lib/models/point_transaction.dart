import 'package:equatable/equatable.dart';

class PointTransaction extends Equatable {
  final int? id;
  final int userId;
  final int rewardId;
  final String rewardName;
  final int amount;
  final DateTime createdAt;

  const PointTransaction({
    this.id,
    required this.userId,
    required this.rewardId,
    required this.amount,
    required this.createdAt,
    required this.rewardName,
  });

  factory PointTransaction.fromJson(Map<String, dynamic> json) {
    return PointTransaction(
      id: json['id'] as int?,
      userId: json['userId'] as int,
      rewardId: json['rewardId'] as int,
      amount: json['amount'] as int,
      createdAt: DateTime.parse(json['createdAt']),
      rewardName: json['rewardName'] as String,
    );
  }

  @override
  List<Object?> get props => [id, userId, rewardId, amount, createdAt,rewardName];
}