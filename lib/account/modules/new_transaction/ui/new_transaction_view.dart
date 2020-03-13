import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:expense_tracker_app/account/helper/utils.dart';
import 'package:expense_tracker_app/account/modules/new_transaction/bloc/new_transaction_bloc.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class NewTransactionView extends StatelessWidget {
  final TextEditingController controller = TextEditingController(
      text: DateFormat('dd/mm/yyyy HH:mm').format(DateTime.now()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        actions: <Widget>[
          NewTransaccionSaveButton(),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Type:',
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.w600),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10.0,
                ),
                BlocBuilder<NewTransactionBloc, NewTransactionEvent>(
                  condition: (previousState, state) =>
                      (state.eventType ??
                          NewTransactionEventType.transactionTypeChanged) ==
                      NewTransactionEventType.transactionTypeChanged,
                  builder: (context, state) => Wrap(
                    children: BlocProvider.of<NewTransactionBloc>(context)
                                .categories ==
                            null
                        ? []
                        : BlocProvider.of<NewTransactionBloc>(context)
                            .categories
                            .keys
                            .map(
                              (type) => InkWell(
                                customBorder: CircleBorder(),
                                onTap: () =>
                                    BlocProvider.of<NewTransactionBloc>(context)
                                        .add(Event(
                                            NewTransactionEventType
                                                .transactionTypeChanged,
                                            data: type)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: type.id ==
                                              BlocProvider.of<
                                                          NewTransactionBloc>(
                                                      context)
                                                  .newTransaction
                                                  .type
                                                  .id
                                          ? Colors.blue
                                          : Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  padding: EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  margin: EdgeInsets.all(5.0),
                                  child: Text(
                                    '${type.name[0].toUpperCase()}${type.name.substring(1)}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: type.id ==
                                                BlocProvider.of<
                                                            NewTransactionBloc>(
                                                        context)
                                                    .newTransaction
                                                    .type
                                                    .id
                                            ? Colors.white
                                            : Colors.white60),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 40.0,
                ),
                Text(
                  'Account:',
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.w600),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10.0,
                ),
                BlocBuilder<NewTransactionBloc, NewTransactionEvent>(
                  condition: (previousState, state) =>
                      (state.eventType ??
                          NewTransactionEventType.transactionAccountChanged) ==
                      NewTransactionEventType.transactionAccountChanged,
                  builder: (context, state) => Wrap(
                    children: BlocProvider.of<NewTransactionBloc>(context)
                                .accountBloc ==
                            null
                        ? []
                        : BlocProvider.of<NewTransactionBloc>(context)
                            .accountBloc
                            .accounts
                            .map(
                              (account) => InkWell(
                                customBorder: CircleBorder(),
                                onTap: () =>
                                    BlocProvider.of<NewTransactionBloc>(context)
                                        .add(Event(
                                            NewTransactionEventType
                                                .transactionAccountChanged,
                                            data: account)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: account.id ==
                                              BlocProvider.of<
                                                          NewTransactionBloc>(
                                                      context)
                                                  .newTransaction
                                                  .accountId
                                          ? Colors.blue
                                          : Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  padding: EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  margin: EdgeInsets.all(5.0),
                                  child: Text(
                                    '${account.name} ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: account.id ==
                                                BlocProvider.of<
                                                            NewTransactionBloc>(
                                                        context)
                                                    .newTransaction
                                                    .accountId
                                            ? Colors.white
                                            : Colors.white60),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 40.0,
                ),
                Text(
                  'Category:',
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.w600),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10.0,
                ),
                BlocBuilder<NewTransactionBloc, NewTransactionEvent>(
                  condition: (previousState, state) =>
                      (state.eventType ??
                          NewTransactionEventType.transactionCategoryChanged) ==
                      NewTransactionEventType.transactionCategoryChanged,
                  builder: (context, state) => Wrap(
                    children: BlocProvider.of<NewTransactionBloc>(context)
                                .categories ==
                            null
                        ? []
                        : BlocProvider.of<NewTransactionBloc>(context)
                            .categories[
                                BlocProvider.of<NewTransactionBloc>(context)
                                    .newTransaction
                                    .type]
                            .map(
                              (category) => InkWell(
                                customBorder: CircleBorder(),
                                onTap: () =>
                                    BlocProvider.of<NewTransactionBloc>(context)
                                        .add(Event(
                                            NewTransactionEventType
                                                .transactionCategoryChanged,
                                            data: category)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:
                                          BlocProvider.of<NewTransactionBloc>(
                                                          context)
                                                      .newTransaction
                                                      .category ==
                                                  category
                                              ? Colors.blue
                                              : Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  padding: EdgeInsets.fromLTRB(
                                      15.0, 10.0, 15.0, 10.0),
                                  margin: EdgeInsets.all(5.0),
                                  child: Text(
                                    '${category.name}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                            BlocProvider.of<NewTransactionBloc>(
                                                            context)
                                                        .newTransaction
                                                        .category ==
                                                    category
                                                ? Colors.white
                                                : Colors.white60),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 40.0,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Date:',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600),
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 10.0,
                          ),
                          DateTimeField(
                            controller: controller,
                            style: TextStyle(fontSize: 16.0),
                            format: DateFormat('dd/mm/yyyy HH:mm'),
                            decoration: InputDecoration(
                              hintText: 'Select a date',
                              hintStyle: TextStyle(
                                  fontSize: 15.0, color: Colors.blueGrey),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                            ),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2019),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2021));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );

                                BlocProvider.of<NewTransactionBloc>(context)
                                    .add(Event(
                                        NewTransactionEventType
                                            .transcationDateChanged,
                                        data:
                                            DateTimeField.combine(date, time)));

                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(
                      width: 30.0,
                      color: Colors.transparent,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Amount:',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600),
                          ),
                          Divider(
                            color: Colors.transparent,
                            height: 10.0,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                              suffix: Text(NumberFormat.simpleCurrency(
                                locale:
                                    Localizations.localeOf(context).toString(),
                              ).currencySymbol),
                            ),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 2),
                            ],
                            onChanged: (amount) {
                              print('envio -> $amount');
                              BlocProvider.of<NewTransactionBloc>(context).add(
                                  Event(
                                      NewTransactionEventType
                                          .transactionAmountChanged,
                                      data: double.parse(
                                              amount.replaceAll(',', '.')) ??
                                          0.0));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewTransaccionSaveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewTransactionBloc, NewTransactionEvent>(
      listenWhen: (previousState, state) =>
          (state.eventType ??
                  NewTransactionEventType.transactionSaveButtonPressed) ==
              NewTransactionEventType.transactionSaveButtonPressed &&
          ((state.runtimeType ?? Event) == Success ||
              (state.runtimeType ?? Event) == Failure),
      listener: (previousState, state) async {
        if (state.runtimeType == Success) {
          Navigator.of(context).pop();
        } else {
          Flushbar(
            duration: Duration(milliseconds: 1500),
            borderRadius: 10.0,
            margin: EdgeInsets.all(10.0),
            backgroundColor: Colors.black.withOpacity(0.8),
            message: ('Error: All the form fields are required.'),
          ).show(context);
        }
      },
      buildWhen: (previosState, state) =>
          (state.eventType ??
              NewTransactionEventType.transactionSaveButtonPressed) ==
          NewTransactionEventType.transactionSaveButtonPressed,
      builder: (context, state) => state.runtimeType == Loading
          ? Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Center(
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 3.0,
                  ),
                ),
              ),
            )
          : IconButton(
              onPressed: () => BlocProvider.of<NewTransactionBloc>(context).add(
                  Event(NewTransactionEventType.transactionSaveButtonPressed)),
              icon: Icon(Icons.save_alt),
            ),
    );
  }
}
