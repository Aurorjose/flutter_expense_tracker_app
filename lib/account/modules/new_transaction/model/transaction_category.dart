import 'package:sqflite/sqflite.dart' as sqflite;

final String tableTransactionCategory = 'transactionCategory';
final String columnId = '_id';
final String columnName = 'name';
final String columnType = 'fkType';

class TransactionCategory {
  final int id;
  final String name;
  final int typeId;

  TransactionCategory({
    this.id,
    this.name,
    this.typeId,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnId: id,
      columnName: name,
      columnType: typeId,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  TransactionCategory.fromMap(Map<String, dynamic> map)
      : this(id: map[columnId], name: map[columnName], typeId: map[columnType]);
}

class TransactionCategoryProvider {
  sqflite.Database db;

  Future open(String path) async {
    db = await sqflite.openDatabase(path, version: 1);
    await checkTableExists();
  }

  Future<bool> checkTableExists() async {
    List<Map> maps = await db.rawQuery(
        'select name from sqlite_master where type = "table" and name = "$TransactionCategory"');
    if (maps.length == 0) {
      await db.execute('''
        create table $TransactionCategory ( 
        $columnId integer primary key autoincrement, 
        $columnName text not null,
        $columnType integer not null)
      ''');

      await db.execute(''' 
        insert into $TransactionCategory (
          $columnName,
          $columnType
        )
        values (
          "Health Care",
          1
        )
      ''');

      await db.execute(''' 
        insert into $TransactionCategory (
          $columnName,
          $columnType
        )
        values (
          "Restaurants",
          1
        )
      ''');

      await db.execute(''' 
        insert into $TransactionCategory (
          $columnName,
          $columnType
        )
        values (
          "Clothes",
          1
        )
      ''');

      await db.execute(''' 
        insert into $TransactionCategory (
          $columnName,
          $columnType
        )
        values (
          "Food",
          1
        )
      ''');

      await db.execute(''' 
        insert into $TransactionCategory (
          $columnName,
          $columnType
        )
        values (
          "Salary",
          2
        )
      ''');

      await db.execute(''' 
        insert into $TransactionCategory (
          $columnName,
          $columnType
        )
        values (
          "Capital Gain",
          2
        )
      ''');

      await db.execute(''' 
        insert into $TransactionCategory (
          $columnName,
          $columnType
        )
        values (
          "Rental",
          2
        )
      ''');
    }

    return true;
  }

  Future<List<TransactionCategory>> getTransactionCategories() async {
    List<Map> maps = await db.query(tableTransactionCategory,
        columns: [columnId, columnName, columnType]);

    List<TransactionCategory> accounts = [];
    for (final map in maps) {
      accounts.add(TransactionCategory.fromMap(map));
    }

    return accounts;
  }

  Future close() async => db.close();
}
