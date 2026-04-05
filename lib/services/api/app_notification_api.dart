import 'package:greenbin/models/app_notification.dart';
import 'package:greenbin/services/http/dio_client.dart';
import 'package:greenbin/utils/api_parser.dart';

import '../../configs/api_endpoint.dart';
import '../../configs/api_error_handle.dart';

class AppNotificationApi {
  final DioClient _dioClient = DioClient();

  Future<List<AppNotification>> getUserNotifications() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getAllNotifications,
      );

      return ApiParser.parseListData(
          response: response,
          fromJson: AppNotification.fromJson,
          listKey: 'notifications');
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> markAsRead({required int notificationId}) async {
    try {
      await _dioClient.patch(ApiEndpoints.markAsRead,
          queryParameters: {'id': notificationId});
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> markAsAllRead() async {
    try {
      await _dioClient.patch(
        ApiEndpoints.markAllAsRead,
      );
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> deleteUserNotificationById({required int id}) async{
    try{
      await _dioClient.delete(
        ApiEndpoints.deleteUserNotificationById,
        queryParameters: {
          'id':id
        }
      );
    }catch(e){
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<void> deleteUserNotifications() async{
    try{
      await _dioClient.delete(
          ApiEndpoints.deleteUserNotifications,
      );
    }catch(e){
      throw ApiErrorHandler.handle(e);
    }
  }


}
