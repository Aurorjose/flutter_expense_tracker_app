import 'package:expense_tracker_app/account/repository/account_data_provider.dart';
import 'package:expense_tracker_app/account/model/account.dart';

class AccountRepository {
  final AccountDataProvider provider = AccountDataProvider();

  Future<List<Account>> getAccountList() => provider.getAccountList();

  Future<int> deleteTransaction(int transcationId) =>
      provider.deleteTransaction(transcationId);
}
