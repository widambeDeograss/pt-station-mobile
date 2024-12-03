import 'package:flutter/foundation.dart';
import 'package:pts/models/pump_status_model.dart';

class PumpStatusNotifier extends ChangeNotifier {
  PumpStatusModel? _pumpStatus;
  PumpStatusModel? get pumpstatus => _pumpStatus;

  pumpStatus(PumpStatusModel pumpStatus) async {
    _pumpStatus = pumpStatus;
    notifyListeners();
  }
}
