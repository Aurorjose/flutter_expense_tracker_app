import 'package:expense_tracker_app/account/bloc/account_bloc.dart';
import 'package:expense_tracker_app/account/model/account.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/bloc/new_transaction_bloc.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/model/transaction_type.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/repository/new_transaction_repository.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/ui/new_transaction_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsView extends StatefulWidget {
  @override
  _AccountsViewState createState() => _AccountsViewState();
}

class _AccountsViewState extends State<AccountsView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final AccountBloc accountBloc = BlocProvider.of<AccountBloc>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RepositoryProvider(
              create: (_) => NewTransactionRepository(),
              child: BlocProvider<NewTransactionBloc>(
                create: (BuildContext context) => NewTransactionBloc(
                  Transaction.init(TransactionType(id: 1, name: 'expense')),
                  RepositoryProvider.of<NewTransactionRepository>(context),
                  accountBloc,
                ),
                child: NewTransactionView(),
              ),
            ),
          ),
        ),
        child: Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: false,
            snap: false,
            elevation: 2.0,
            title: Text('Dashboard'),
            centerTitle: true,
            actions: <Widget>[],
          ),
          SliverList(
            //itemExtent: MediaQuery.of(context).size.height,
            delegate: SliverChildListDelegate(
              [
                BlocConsumer<AccountBloc, AccountEvent>(
                  listenWhen: (previousState, state) =>
                      state.eventType == AccountEventType.transactionAdded ||
                      state.eventType == AccountEventType.transactionDeleted,
                  listener: (context, state) {
                    switch (state.eventType) {
                      case AccountEventType.transactionAdded:
                        break;
                      case AccountEventType.transactionDeleted:
                        // TODO: Handle this case.
                        break;
                      default:
                        break;
                    }
                  },
                  builder: (context, state) => state.data == null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : Column(
                          children: (state.data as List<Account>)
                              .map(
                                (account) => Column(
                                  children: <Widget>[
                                    Container(
                                      color: Colors.grey,
                                      padding: EdgeInsets.fromLTRB(
                                          15.0, 10.0, 15.0, 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            account.name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '${account.getBalance().toStringAsFixed(2)} ${NumberFormat.simpleCurrency(
                                              locale: Localizations.localeOf(
                                                      context)
                                                  .toString(),
                                            ).currencySymbol}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                    account.transactions.length == 0
                                        ? Container(
                                            padding: EdgeInsets.fromLTRB(
                                                20.0, 15.0, 20.0, 15.0),
                                            child: Text(
                                              'This account has no transactions yet',
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          )
                                        : Column(
                                            children: account.transactions
                                                .getRange(
                                                    0,
                                                    account.transactions
                                                                .length >
                                                            10
                                                        ? 11
                                                        : account.transactions
                                                            .length)
                                                .map((transaction) => Column(
                                                      children: <Widget>[
                                                        AccountTransactionView(
                                                            transaction:
                                                                transaction),
                                                        account.transactions.indexOf(
                                                                        transaction) ==
                                                                    10 &&
                                                                account.transactions
                                                                            .length -
                                                                        10 >
                                                                    0
                                                            ? Column(
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    width:
                                                                        100.0,
                                                                    child: Divider(
                                                                        height:
                                                                            0.0,
                                                                        color: Colors
                                                                            .grey),
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10.0),
                                                                    child: Text(
                                                                      '+ ${account.transactions.length - 10} transactions',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            11.0,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
                                                      ],
                                                    ))
                                                .toList(),
                                          ),
                                  ],
                                ),
                              )
                              .toList(),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class AccountTransactionView extends StatelessWidget {
  AccountTransactionView({Key key, this.transaction}) : super(key: key);

  final Transaction transaction;
  final SlidableController slidableController = new SlidableController();

  @override
  Widget build(BuildContext context) {
    return Slidable(
      controller: slidableController,
      closeOnScroll: true,
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.30,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Container(
          decoration: BoxDecoration(
              border:
                  Border(top: BorderSide(color: Colors.grey.withOpacity(0.2)))),
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${transaction.category.name}',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    Divider(
                      color: Colors.transparent,
                      height: 10.0,
                    ),
                    Text(
                      '${DateFormat('dd/mm/yyyy HH:ss').format(transaction.date)}',
                      style: TextStyle(
                          fontSize: 12.0, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              Text(
                '${transaction.type.id == 1 ? '-' : ''}${transaction.amount.toStringAsFixed(2)} ${NumberFormat.simpleCurrency(
                  locale: Localizations.localeOf(context).toString(),
                ).currencySymbol}',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color:
                        transaction.type.id == 1 ? Colors.red : Colors.green),
              )
            ],
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: () => BlocProvider.of<AccountBloc>(context).add(AccountEvent(
              AccountEventType.transactionDeleted,
              data: transaction)),
        ),
      ],
    );
  }
}
