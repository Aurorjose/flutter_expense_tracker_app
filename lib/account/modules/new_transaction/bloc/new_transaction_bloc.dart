import 'package:bloc/bloc.dart';
import 'package:expense_tracker_app/account/bloc/account_bloc.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction_category.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction_type.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/repository/new_transaction_repository.dart';

enum NewTransactionEventType {
  transactionStarted,
  transactionTypeChanged,
  transactionAccountChanged,
  transactionCategoryChanged,
  transcationDateChanged,
  transactionAmountChanged,
  transactionSaveButtonPressed,
}

abstract class NewTransactionEvent {
  final NewTransactionEventType eventType;
  final dynamic data;

  NewTransactionEvent(this.eventType, {this.data});
}

class Event extends NewTransactionEvent {
  Event(NewTransactionEventType eventType, {dynamic data})
      : super(eventType, data: data);
}

class Loading extends NewTransactionEvent {
  Loading(NewTransactionEventType eventType, {dynamic data})
      : super(eventType, data: data);
}

class Success extends NewTransactionEvent {
  Success(NewTransactionEventType eventType, {dynamic data})
      : super(eventType, data: data);
}

enum FailureErrorType {
  requestError,
  formError,
}

class Failure extends NewTransactionEvent {
  final FailureErrorType error;
  Failure(NewTransactionEventType eventType, {dynamic data, this.error})
      : super(eventType, data: data);
}

class NewTransactionBloc
    extends Bloc<NewTransactionEvent, NewTransactionEvent> {
  final Transaction newTransaction;
  final NewTransactionRepository repository;
  final AccountBloc accountBloc;
  Map<TransactionType, List<TransactionCategory>> categories;

  NewTransactionBloc(this.newTransaction, this.repository, this.accountBloc) {
    this.add(Event(NewTransactionEventType.transactionStarted));
  }

  @override
  NewTransactionEvent get initialState => Event(null);

  @override
  Stream<NewTransactionEvent> mapEventToState(
      NewTransactionEvent event) async* {
    switch (event.eventType) {
      case NewTransactionEventType.transactionStarted:
        categories = await repository.getCategories();
        for (final type in categories.keys) {
          if (type.id == newTransaction.type.id) {
            print('entra');
            newTransaction.type = type;
          }
        }
        yield Event(null);
        break;

      case NewTransactionEventType.transactionTypeChanged:
        if (newTransaction.type != event.data) {
          newTransaction.type = event.data;
          yield event;
          this.add(Event(NewTransactionEventType.transactionCategoryChanged,
              data: null));
        }
        break;
      case NewTransactionEventType.transactionAccountChanged:
        newTransaction.accountId = event.data.id;
        yield event;
        break;
      case NewTransactionEventType.transactionCategoryChanged:
        newTransaction.category = event.data;
        yield event;
        break;
      case NewTransactionEventType.transcationDateChanged:
        newTransaction.date = event.data;
        break;
      case NewTransactionEventType.transactionAmountChanged:
        newTransaction.amount = event.data;

        break;
      case NewTransactionEventType.transactionSaveButtonPressed:
        yield Loading(event.eventType);
        print(newTransaction.amount);
        if (newTransaction.accountId == null ||
            newTransaction.category == null ||
            (newTransaction.amount ?? 0.0) <= 0.0) {
          yield Failure(event.eventType, error: FailureErrorType.formError);
        } else {
          //TODO control if the transaction has been added sucessfuly
          Transaction transaction =
              await repository.newTransaction(newTransaction);
          newTransaction.id = transaction.id;
          for (final account in accountBloc.accounts) {
            if (account.id == newTransaction.accountId) {
              List<List<Transaction>> combined = [
                [newTransaction],
                account.transactions,
              ];

              account.transactions =
                  combined.reduce((map1, map2) => map1..addAll(map2));
            }
          }
          accountBloc.add(AccountEvent(AccountEventType.transactionAdded,
              data: accountBloc.accounts));
          await Future.delayed(Duration(milliseconds: 600));
          yield Success(event.eventType);
        }

        break;
    }
  }
}
