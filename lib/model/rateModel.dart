import 'package:exchange_rates/db/database_provider.dart';

class Rate {
  String name;
  double value;

  Rate({this.name, this.value});

  factory Rate.fromJson(name, value) {
    DatabaseProvider.db.insert(Rate(
      name: name,
      value: value,
    ));
    return Rate(
      name: name,
      value: value,
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.CURRENCY_NAME: name,
      DatabaseProvider.VALUE: value,
    };
    return map;
  }

  Rate.fromMap(Map<String, dynamic> map) {
    name = map[DatabaseProvider.CURRENCY_NAME];
    value = map[DatabaseProvider.VALUE];
  }
}
