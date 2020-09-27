import 'package:exchange_rates/model/rateModel.dart';

class Rates {
  List<Rate> rateList;

  Rates({this.rateList});

  factory Rates.fromJson(Map<String, dynamic> json) {
    List<Rate> rates = new List();
    rates.add(Rate.fromJson("CAD", json["CAD"]));
    rates.add(Rate.fromJson("HKD", json["HKD"]));
    rates.add(Rate.fromJson("ISK", json["ISK"]));
    rates.add(Rate.fromJson("PHP", json["PHP"]));
    rates.add(Rate.fromJson("DKK", json["DKK"]));
    rates.add(Rate.fromJson("HUF", json["HUF"]));
    rates.add(Rate.fromJson("CZK", json["CZK"]));
    rates.add(Rate.fromJson("AUD", json["AUD"]));
    rates.add(Rate.fromJson("RON", json["RON"]));
    rates.add(Rate.fromJson("SEK", json["SEK"]));
    rates.add(Rate.fromJson("IDR", json["IDR"]));
    rates.add(Rate.fromJson("INR", json["INR"]));
    rates.add(Rate.fromJson("BRL", json["BRL"]));
    rates.add(Rate.fromJson("RUB", json["RUB"]));
    rates.add(Rate.fromJson("HRK", json["HRK"]));
    rates.add(Rate.fromJson("JPY", json["JPY"]));
    rates.add(Rate.fromJson("THB", json["THB"]));
    rates.add(Rate.fromJson("CHF", json["CHF"]));
    rates.add(Rate.fromJson("SGD", json["SGD"]));
    rates.add(Rate.fromJson("PLN", json["PLN"]));
    rates.add(Rate.fromJson("BGN", json["BGN"]));
    rates.add(Rate.fromJson("TRY", json["TRY"]));
    rates.add(Rate.fromJson("CNY", json["CNY"]));
    rates.add(Rate.fromJson("NOK", json["NOK"]));
    rates.add(Rate.fromJson("NZD", json["NZD"]));
    rates.add(Rate.fromJson("ZAR", json["ZAR"]));
    rates.add(Rate.fromJson("USD", json["USD"]));
    rates.add(Rate.fromJson("MXN", json["MXN"]));
    rates.add(Rate.fromJson("ILS", json["ILS"]));
    rates.add(Rate.fromJson("GBP", json["GBP"]));
    rates.add(Rate.fromJson("KRW", json["KRW"]));
    rates.add(Rate.fromJson("MYR", json["MYR"]));

    return Rates(rateList: rates);
  }
}
