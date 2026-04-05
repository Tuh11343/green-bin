import '../../models/bin.dart';
import '../../services/api/app_api.dart';
import '../configs/exception.dart';

abstract class IBinRepository {
  Future<List<Bin>> getAllBins();
}

class BinRepository implements IBinRepository {
  final _api = AppApi().bin;

  @override
  Future<List<Bin>> getAllBins() async {
    try {
      return await _api.getAllBins();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException("Lỗi lấy tất cả bin");
    }
  }
}
