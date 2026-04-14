
import 'package:greenbin/models/enums.dart';

import '../../../models/bin.dart';

abstract class BinListEvent {}

class QueryChanged extends BinListEvent {
  final String query;

  QueryChanged(this.query);
}

class LocateMe extends BinListEvent {}

class FetchBins extends BinListEvent{}

class SelectBin extends BinListEvent {
  final Bin bin;

  SelectBin(this.bin);
}

class ClearSelectedBin extends BinListEvent{

}

class UpdateFilter extends BinListEvent {
  final BinType? type;
  final FillLevel? fillLevel;

  UpdateFilter({this.type, this.fillLevel});
}

class ClearFilter extends BinListEvent {}