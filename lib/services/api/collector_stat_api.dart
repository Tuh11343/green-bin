import 'package:greenbin/services/http/dio_client.dart';

import '../../configs/api_endpoint.dart';
import '../../models/collector_stat.dart';

class CollectorTaskApi {
  final DioClient _dioClient = DioClient();

  Future<CollectorStat> getCollectorStat() async {
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getCollectorStat,
      );

      if (response.statusCode == 200 && response.data != null) {
        final collectionTaskData = response.data['data'];
        return CollectorStat.fromJson(collectionTaskData);
      } else {
        throw Exception('Get Collector Stat failed: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
