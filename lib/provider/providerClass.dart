import 'package:exchange_rates/model/rateModel.dart';
import 'package:flutter/foundation.dart';

class ProviderClass with ChangeNotifier {
  List<Rate> _rateList = new List();

  List<Rate> get rateList => _rateList;

  set rateList(List<Rate> value) {
    _rateList = value;
    notifyListeners();
  }
}
