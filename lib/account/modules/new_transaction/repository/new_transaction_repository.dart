import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction_category.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction_type.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/repository/new_transaction_data_provider.dart';

class NewTransactionRepository {
  final NewTransactionDataProvider provider = NewTransactionDataProvider();

  Future<Transaction> newTransaction(Transaction transaction) =>
      provider.newTransaction(transaction);

  Future<Map<TransactionType, List<TransactionCategory>>> getCategories() =>
      provider.getCategories();
}
