import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:exchange_rates/model/rateModel.dart';

class DatabaseProvider {
  static const String EXCHANGE_RATE = "rate";
  static const String COLUMN_ID = "id";
  static const String CURRENCY_NAME = "name";
  static const String VALUE = "value";

  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, "exchangeRateDB.db"),
      version: 1,
      onCreate: (Database database, int version) async {
        await database.execute(
          "Create Table $EXCHANGE_RATE ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$CURRENCY_NAME TEXT,"
          "$VALUE DOUBLE"
          ")",
        );
      },
    );
  }

  Future<List<Rate>> getRates() async {
    final db = await database;

    var rates = await db
        .query(EXCHANGE_RATE, columns: [COLUMN_ID, CURRENCY_NAME, VALUE]);
    List<Rate> rateList = new List();
    rates.forEach((rateDetail) {
      Rate rate = Rate.fromMap(rateDetail);
      rateList.add(rate);
    });
    return rateList;
  }

  Future<Rate> insert(Rate rate) async {
    final db = await database;
    await db.insert(EXCHANGE_RATE, rate.toMap());
    return rate;
  }

  Future<int> deleteAllData() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM $EXCHANGE_RATE');
    return res;
  }
}
