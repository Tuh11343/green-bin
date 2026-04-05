import 'package:equatable/equatable.dart';
import '../../models/report.dart';

enum ReportStatusState { initial, loading, success, failure }
enum ReportAction { none, fetchRecent, fetchAll, create }

class ReportState extends Equatable {
  final ReportStatusState status;
  final ReportAction action;
  final List<Report> reports;
  final String? message;

  const ReportState({
    this.status = ReportStatusState.initial,
    this.action = ReportAction.none,
    this.reports = const [],
    this.message,
  });

  ReportState copyWith({
    ReportStatusState? status,
    ReportAction? action,
    List<Report>? reports,
    String? message,
  }) {
    return ReportState(
      status: status ?? this.status,
      action: action ?? this.action,
      reports: reports ?? this.reports,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, action, reports, message];
}