import 'package:sqflite/sqflite.dart' as sqflite;

final String tableTransactionType = 'transactionType';
final String columnId = '_id';
final String columnName = 'name';

class TransactionType {
  final int id;
  final String name;

  TransactionType({
    this.id,
    this.name,
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

  TransactionType.fromMap(Map<String, dynamic> map)
      : this(id: map[columnId], name: map[columnName]);
}

class TransactionTypeProvider {
  sqflite.Database db;

  Future open(String path) async {
    db = await sqflite.openDatabase(path, version: 1);
    await checkTableExists();
  }

  Future<bool> checkTableExists() async {
    List<Map> maps = await db.rawQuery(
        'select name from sqlite_master where type = "table" and name = "$tableTransactionType"');
    if (maps.length == 0) {
      await db.execute('''
        create table $tableTransactionType ( 
        $columnId integer primary key autoincrement, 
        $columnName text not null)
      ''');

      await db.execute(''' 
        insert into $tableTransactionType (
          $columnName
        )
        values (
          "expense"
        )
      ''');

      await db.execute(''' 
        insert into $tableTransactionType (
          $columnName
        )
        values (
          "income"
        )
      ''');
    }

    return true;
  }

  Future<List<TransactionType>> getTransactionTypes() async {
    List<Map> maps =
        await db.query(tableTransactionType, columns: [columnId, columnName]);

    List<TransactionType> accounts = [];
    for (final map in maps) {
      accounts.add(TransactionType.fromMap(map));
    }

    return accounts;
  }

  Future close() async => db.close();
}
