import 'package:bloc/bloc.dart';
import 'package:expense_tracker_app/account/model/account.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction.dart';
import 'package:expense_tracker_app/account/repository/account_repository.dart';

enum AccountEventType {
  retrieveExpenseAccountsListRequested,
  transactionAdded,
  transactionDeleted,
}

class AccountEvent {
  final AccountEventType eventType;
  dynamic data;

  AccountEvent(this.eventType, {this.data});
}

class AccountBloc extends Bloc<AccountEvent, AccountEvent> {
  final AccountRepository repository;
  List<Account> accounts;

  @override
  AccountEvent get initialState =>
      AccountEvent(AccountEventType.retrieveExpenseAccountsListRequested,
          data: null);

  AccountBloc(this.repository) {
    this.add(
        AccountEvent(AccountEventType.retrieveExpenseAccountsListRequested));
  }

  @override
  Stream<AccountEvent> mapEventToState(AccountEvent event) async* {
    switch (event.eventType) {
      case AccountEventType.retrieveExpenseAccountsListRequested:
        accounts = await repository.getAccountList();
        event.data = accounts;
        yield event;
        break;
      case AccountEventType.transactionAdded:
        yield event;
        break;
      case AccountEventType.transactionDeleted:
        //TODO control if the transaction has been deleted sucessfuly
        int deleted =
            await repository.deleteTransaction((event.data as Transaction).id);
        print('deleted -> $deleted');
        for (final account in accounts) {
          if (account.id == (event.data as Transaction).accountId) {
            account.transactions.remove(event.data);
          }
        }
        event.data = accounts;
        yield event;
        break;
    }
  }
}
