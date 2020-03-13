import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction_category.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction_type.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'package:path/path.dart';

class NewTransactionDataProvider {
  Future<Transaction> newTransaction(Transaction transaction) async {
    var databasesPath = await sqflite.getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    TransactionProvider provider = TransactionProvider();
    await provider.open(path);
    transaction = await provider.insert(transaction);
    await provider.close();

    print('transaction -> ${transaction.toMap()}');

    return transaction;
  }

  Future<Map<TransactionType, List<TransactionCategory>>>
      getCategories() async {
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
    await typeProvider.close();

    for (final type in types) {
      print(type.toMap());
    }

    Map<TransactionType, List<TransactionCategory>> result = {};

    for (final type in types) {
      List<TransactionCategory> typeCategories = [];
      for (final category in categories) {
        if (category.typeId == type.id) {
          typeCategories.add(category);
        }
      }

      result.addAll({type: typeCategories});
    }

    print(result);

    return result;
  }
}
