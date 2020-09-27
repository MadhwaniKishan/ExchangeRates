import 'dart:convert';

import 'package:exchange_rates/api/apiCall.dart';
import 'package:exchange_rates/constants.dart' as Constants;
import 'package:exchange_rates/db/database_provider.dart';
import 'package:exchange_rates/model/exchangeRateModel.dart';
import 'package:exchange_rates/provider/providerClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/rateModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderClass>(
      builder: (_) => ProviderClass(),
      child: MaterialApp(
        title: 'Exchange Rates',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: 'Euro'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final currencyController = TextEditingController(text: "");
  double euroInput = 1;
  final FocusNode _convertFocusNode = FocusNode();
  static final DateTime now = DateTime.now();
  String formattedDate = DateFormat('m/dd/yyyy HH:MM').format(now);
  bool showIndicator = false;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
    DatabaseProvider.db.getRates().then((rateList) => {
          if (rateList.length <= 0)
            {getNewData(context)}
          else
            {Provider.of<ProviderClass>(context).rateList = rateList}
        });
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      formattedDate = prefs.getString("date");
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Rate> rateList = Provider.of<ProviderClass>(context).rateList;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.title),
              Text(
                'last refresh on $formattedDate',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () => getNewData(context),
            child: Text("Refresh"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: showIndicator
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: () => _convertFocusNode.unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextField(
                        focusNode: _convertFocusNode,
                        enableInteractiveSelection: true,
                        scrollPadding: EdgeInsets.all(10),
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp('[, -]')),
                        ],
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: currencyController,
                      ),
                    ),
                    FlatButton(
                      textColor: Colors.black,
                      onPressed: () => convertCurrencies(),
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      color: Colors.grey,
                      child: Text("Convert"),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 3,
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: new NeverScrollableScrollPhysics(),
                        primary: false,
                        itemBuilder: (ctx, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(rateList[index].name + ": "),
                              Text((rateList[index].value * euroInput)
                                  .toStringAsFixed(2)),
                            ],
                          );
                        },
                        itemCount: rateList.length,
                      ),
                    ),
                  ],
                ),
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  convertCurrencies() {
    _convertFocusNode.unfocus();
    setState(() {
      euroInput = double.parse(currencyController.text);
    });
  }

  getNewData(context) async {
    startIndicator();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('M/dd/yyyy HH:m').format(now);
    setState(() {
      this.formattedDate = formattedDate;
    });
    prefs.setString('date', formattedDate);
    DatabaseProvider.db.deleteAllData().then((value) {
      fetchExchangeRates(Constants.exchangeRateApi).then((value) async {
        if (value.statusCode == 200) {
          ExchangeRateModel exchangeRateModel =
              ExchangeRateModel.fromJson(json.decode(value.body));
          DatabaseProvider.db.getRates().then((rateList) =>
              {Provider.of<ProviderClass>(context).rateList = rateList});
        } else {
          throw Exception('Failed to load album');
        }
      });
    });
    stopIndicator();
  }

  startIndicator() {
    setState(() {
      showIndicator = true;
    });
  }

  stopIndicator() {
    setState(() {
      showIndicator = false;
    });
  }
}
