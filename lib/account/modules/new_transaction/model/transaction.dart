import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction_category.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction_type.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'package:path/path.dart';

final String tableTransaction = 'transactions';
final String columnId = '_id';
final String columnAccountId = 'accountId';
final String columnType = 'fkType';
final String columnCategory = 'fkCategory';
final String columnAmount = 'amount';
final String columnDate = 'date';

class Transaction {
  int id;
  int accountId;
  TransactionType type;
  TransactionCategory category;
  double amount;
  DateTime date;

  Transaction({
    this.id,
    this.accountId,
    this.type,
    this.category,
    this.amount,
    this.date,
  });

  Transaction.init(type) : this(type: type, date: DateTime.now());

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnAccountId: accountId,
      columnType: type.id,
      columnCategory: category.id,
      columnAmount: amount,
      columnDate: date.toString(),
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Transaction.fromMap(Map<String, dynamic> map)
      : this(
            id: map[columnId],
            accountId: map[columnAccountId],
            type: map[columnType],
            category: map[columnCategory],
            amount: map[columnAmount],
            date: DateTime.parse(map[columnDate]));
}

class TransactionProvider {
  sqflite.Database db;

  Future open(String path) async {
    db = await sqflite.openDatabase(path, version: 1);
    await checkTableExists();
  }

  Future<bool> checkTableExists() async {
    List<Map> maps = await db.rawQuery(
        'select name from sqlite_master where type = "table" and name = "$tableTransaction"');
    if (maps.length == 0) {
      await db.execute('''
        create table $tableTransaction ( 
        $columnId integer primary key autoincrement, 
        $columnAccountId integer not null,
        $columnType integer not null,
        $columnCategory integer not null,
        $columnAmount real not null,
        $columnDate text not null)
      ''');
    }

    return true;
  }

  Future<Transaction> insert(Transaction transaction) async {
    transaction.id = await db.insert(tableTransaction, transaction.toMap());
    return transaction;
  }

  Future<List<Transaction>> getTransactions(int accountId) async {
    var databasesPath = await sqflite.getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    TransactionCategoryProvider categoryProvider =
        TransactionCategoryProvider();
    await categoryProvider.open(path);
    List<TransactionCategory> categories =
        await categoryProvider.getTransactionCategories();

    for (final category in categories) {
      print(category.toMap());
    }

    TransactionTypeProvider typeProvider = TransactionTypeProvider();
    await typeProvider.open(path);
    List<TransactionType> types = await typeProvider.getTransactionTypes();

    for (final type in types) {
      print(type.toMap());
    }

    List<Map> maps = await db.query(tableTransaction,
        columns: [
          columnId,
          columnAccountId,
          columnType,
          columnCategory,
          columnAmount,
          columnDate
        ],
        where: '$columnAccountId = ?',
        whereArgs: [accountId],
        orderBy: '$columnId desc');

    List<Transaction> transactions = [];
    for (final mapRead in maps) {
      Map<String, dynamic> map = Map<String, dynamic>.from(mapRead);
      map[columnType] = types.singleWhere((type) => type.id == map[columnType]);
      map[columnCategory] = categories
          .singleWhere((category) => category.id == map[columnCategory]);
      transactions.add(Transaction.fromMap(map));
    }

    return transactions;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableTransaction, where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async => db.close();
}
