import 'package:expense_tracker_app/account/model/account.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';
import 'package:path/path.dart';

class AccountDataProvider {
  Future<List<Account>> getAccountList() async {
    var databasesPath = await sqflite.getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    AccountProvider accountProvider = AccountProvider();
    await accountProvider.open(path);
    List<Account> accounts = await accountProvider.getAccounts();

    for (final account in accounts) {
      print(account.toMap());
    }

    TransactionProvider transactionProvider = TransactionProvider();
    await transactionProvider.open(path);
    for (final account in accounts) {
      print('consigue transactions de -> ${account.name}');
      account.transactions =
          await transactionProvider.getTransactions(account.id);
      print(account.toMap());
    }
    await transactionProvider.close();

    print('devuelve accounts -> $accounts');
    return accounts;
  }

  Future<int> deleteTransaction(int transcationId) async {
    var databasesPath = await sqflite.getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    TransactionProvider provider = TransactionProvider();
    await provider.open(path);
    int result = await provider.delete(transcationId);
    await provider.close();

    return result;
  }
}
