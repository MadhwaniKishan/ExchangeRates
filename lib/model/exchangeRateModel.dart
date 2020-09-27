import 'package:exchange_rates/model/ratesModel.dart';

class ExchangeRateModel {
  Rates rates;
  String base;
  String date;

  ExchangeRateModel({this.rates, this.base, this.date});

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateModel(
      rates: Rates.fromJson(json['rates']),
      base: json['base'],
      date: json['date'],
    );
  }
}
