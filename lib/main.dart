import 'package:expense_tracker_app/account/bloc/account_bloc.dart';
import 'package:expense_tracker_app/account/repository/account_repository.dart';
import 'package:expense_tracker_app/account/ui/accounts_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'),
          const Locale('es'),
          const Locale('fr'),
          const Locale('de'),
          const Locale('it'),
        ],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child,
        ),
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.latoTextTheme(),
        ),
        home: RepositoryProvider<AccountRepository>(
          create: (_) => AccountRepository(),
          child: BlocProvider<AccountBloc>(
            create: (BuildContext context) =>
                AccountBloc(RepositoryProvider.of<AccountRepository>(context)),
            child: AccountsView(),
          ),
        ),
      ),
    );
  }
}
