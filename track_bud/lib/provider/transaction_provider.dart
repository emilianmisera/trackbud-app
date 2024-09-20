import 'package:flutter/foundation.dart';

class TransactionProvider extends ChangeNotifier {
  bool _shouldReloadChart = false;

  bool get shouldReloadChart => _shouldReloadChart;

  void notifyTransactionAdded() {
    _shouldReloadChart = true;
    notifyListeners();
  }

  void resetReloadFlag() {
    _shouldReloadChart = false;
  }
}
