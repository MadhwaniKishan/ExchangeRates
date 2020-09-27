import 'package:http/http.dart' as http;

Future<http.Response> fetchExchangeRates(apiString) async {
  return await http.get(apiString);
}
