import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import '../../services/database.dart';
import '../loading.dart';
import '../theme.dart';
import '../../models/bank_card.dart';
import '../../models/transaction_record.dart';
import '../../models/user.dart';
import '../../screens/home/home.dart';
import '../../screens/profile/profile.dart';
import '../../screens/statistics/statistics.dart';
import '../../screens/wallet/wallet.dart';
import '../../data/globals.dart' as globals;

enum NavigationEvents {
  HomePageClickedEvent,
  WalletPageClickedEvent,
  StatisticsPageClickedEvent,
  ProfilePageClickedEvent,
}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => Home();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomePageClickedEvent:
        yield Home();
        break;
      case NavigationEvents.WalletPageClickedEvent:
        yield Wallet();
        break;
      case NavigationEvents.StatisticsPageClickedEvent:
        yield Statistics();
        break;
      case NavigationEvents.ProfilePageClickedEvent:
        yield Profile();
        break;
    }
  }
}

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar>
    with SingleTickerProviderStateMixin<NavBar> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    void navRouting(index) {
      print('The current index is : $index');
      switch (index) {
        case 0:
          {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationEvents.HomePageClickedEvent);
          }
          break;
        case 1:
          {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationEvents.WalletPageClickedEvent);
          }
          break;
        case 2:
          {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationEvents.StatisticsPageClickedEvent);
          }
          break;
        case 3:
          {
            BlocProvider.of<NavigationBloc>(context)
                .add(NavigationEvents.ProfilePageClickedEvent);
          }
          break;
      }
    }

    return BottomNavyBar(
      backgroundColor: kBackground,
      selectedIndex: selected,
      showElevation: false,
      onItemSelected: (index) {
        setState(() => selected = index);
        navRouting(selected);
      },
      items: [
        BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              textAlign: TextAlign.center,
            ),
            activeColor: kLightPrimary),
        BottomNavyBarItem(
            icon: Icon(Icons.credit_card),
            title: Text(
              'Wallet',
              textAlign: TextAlign.center,
            ),
            activeColor: kDarkPrimary),
        BottomNavyBarItem(
            icon: Icon(Icons.trending_up),
            title: Text(
              'Statistics',
              textAlign: TextAlign.center,
            ),
            activeColor: kLightSecondary),
        BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text(
              'Profile',
              textAlign: TextAlign.center,
            ),
            activeColor: kDarkSecondary),
      ],
    );
  }
}

class NavBarLayout extends StatefulWidget {
  final CurrentUser user;

  NavBarLayout({Key key, @required this.user}) : super(key: key);

  @override
  _NavBarLayoutState createState() => _NavBarLayoutState();
}

class _NavBarLayoutState extends State<NavBarLayout> {
  bool loading = true;

  StreamController streamController;

  @override
  void initState() {
    streamController = StreamController.broadcast();
    setupData();
    super.initState();
  }

  void setupData() async {
    Stream stream = await DatabaseService(uid: widget.user.uid).createStreams()
      ..asBroadcastStream();
    stream.listen((data) {
      setState(() {
        globals.userData = data[0];
        globals.budget = data[1];

        List<BankCard> cards = new List<BankCard>();
        data[2].forEach((card) {
          cards.add(new BankCard(
            bankName: card['bankName'],
            cardNumber: card['cardNumber'],
            holderName: card['holderName'],
            expiry: DateTime.parse(card['expiry'].toDate().toString()),
          ));
        });
        //Only append the values not found in the existing global variable
        globals.wallet =
            cards.toSet().difference(globals.wallet.toSet()).toList();

        List<TransactionRecord> transactions = new List<TransactionRecord>();
        data[3].forEach((transaction) {
          transactions.add(new TransactionRecord(
              type: transaction['type'],
              title: transaction['title'],
              amount: double.parse(transaction['amount'].toString()),
              date: DateTime.parse(transaction['date'].toDate().toString()),
              cardNumber: transaction['cardNumber']));
        });

        //Only append the values not found in the existing global variable
        globals.transactions = transactions
            .toSet()
            .difference(globals.transactions.toSet())
            .toList();
        globals.income =
            (transactions.where((t) => t.type == "income").toList())
                .fold(0, (i, j) => i + j.amount);
        globals.expense =
            (transactions.where((t) => t.type == "expense").toList())
                .fold(0, (i, j) => i + j.amount);
        globals.monthIncome = (transactions
                .where((t) =>
                    t.type == "income" && t.date.month == DateTime.now().month)
                .toList())
            .fold(0, (i, j) => i + j.amount);
        globals.monthExpense = (transactions
                .where((t) =>
                    t.type == "expense" && t.date.month == DateTime.now().month)
                .toList())
            .fold(0, (i, j) => i + j.amount);
        globals.monthTotal = globals.monthIncome + globals.monthExpense;
      });

      print("USER stream -> ${globals.userData.fullName}");
      print("BUDGET stream -> ${globals.budget.month}th month");
      print("WALLET stream -> ${globals.wallet.length} cards");
      print("TRANSACTIONS stream -> ${globals.transactions.length} records");
      print("~ end of init streams ~");

      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    streamController?.close();
    streamController = null;
    print("STREAM CONTROLLER killed");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NavigationBloc>(
      create: (context) => NavigationBloc(),
      child: loading
          ? Loading()
          : Scaffold(
              key: globals.scaffoldKey,
              backgroundColor: kBackground,
              resizeToAvoidBottomPadding: false,

              ///APPLICATION BODY
              body: SafeArea(
                minimum: EdgeInsets.all(25),
                child: BlocBuilder<NavigationBloc, NavigationStates>(
                    builder: (context, navigationState) {
                  // return navigationState as Widget;

                  setupData();
                  return navigationState as Widget;

                  // return StreamBuilder(
                  //   stream: streamController.stream,
                  //   builder: (context, snapshot) => navigationState as Widget,
                  // );
                }),
              ),

              ///BOTTOM NAVIGATION BAR
              extendBody: true,
              bottomNavigationBar: Container(
                color: kBackground,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: NavBar(),
              )),
    );
  }
}
