import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

final String tableAccount = 'account';
final String columnId = '_id';
final String columnName = 'name';

class Account {
  int id;
  final String name;
  List<Transaction> transactions;

  Account({
    this.id,
    this.name,
    this.transactions,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnName: name,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Account.fromMap(Map<String, dynamic> map)
      : this(id: map[columnId], name: map[columnName], transactions: []);

  double getBalance() {
    double balance = 0.0;

    for (final transaction in this.transactions) {
      balance += (transaction.amount * (transaction.type.id == 1 ? -1 : 1));
    }

    return balance;
  }
}

class AccountProvider {
  sqflite.Database db;

  Future open(String path) async {
    db = await sqflite.openDatabase(path, version: 1);
    await checkTableExists();
  }

  Future<bool> checkTableExists() async {
    List<Map> maps = await db.rawQuery(
        'select name from sqlite_master where type = "table" and name = "$tableAccount"');
    if (maps.length == 0) {
      await db.execute('''
        create table $tableAccount ( 
        $columnId integer primary key autoincrement, 
        $columnName text not null)
      ''');

      await db.execute(''' 
        insert into $tableAccount (
          $columnName
        )
        values (
          "Cash"
        )
      ''');

      await db.execute(''' 
        insert into $tableAccount (
          $columnName
        )
        values (
          "Credit Card"
        )
      ''');

      await db.execute(''' 
        insert into $tableAccount (
          $columnName
        )
        values (
          "Bank Account"
        )
      ''');
    }

    return true;
  }

  Future<Account> insert(Account account) async {
    account.id = await db.insert(tableAccount, account.toMap());
    return account;
  }

  Future<List<Account>> getAccounts() async {
    List<Map> maps =
        await db.query(tableAccount, columns: [columnId, columnName]);

    List<Account> accounts = [];
    for (final map in maps) {
      accounts.add(Account.fromMap(map));
    }

    return accounts;
  }

  Future close() async => db.close();
}
