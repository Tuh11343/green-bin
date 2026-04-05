import 'package:greenbin/services/http/dio_client.dart';

import '../../configs/api_endpoint.dart';
import '../../models/collection_task.dart';

class CollectionTaskApi {
  final DioClient _dioClient = DioClient();

  Future<CollectionTask> submitTask({required CollectionTask collectionTask}) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.submitTask,
        data: collectionTask.toJson()
      );

      if (response.statusCode == 200 && response.data != null) {
        final collectionTaskData = response.data['data'];
        return CollectionTask.fromJson(collectionTaskData);
      } else {
        throw Exception('Submit Task failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<CollectionTask>> getAllCollectionTasks() async {
    try {
      final response = await _dioClient.get(
          ApiEndpoints.getAllCollectionTasks,
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> listData = response.data!['data'];

        return listData.map((json) => CollectionTask.fromJson(json)).toList();
      } else {
        throw Exception('Submit Task failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }




}
