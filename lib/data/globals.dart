library summary.globals;

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bank_card.dart';
import '../models/budget.dart';
import '../models/transaction_record.dart';
import '../models/user.dart';

GlobalKey scaffoldKey = GlobalKey();
  
UserData userData = new UserData();
List<TransactionRecord> transactions = new List<TransactionRecord>();
List<BankCard> wallet = new List<BankCard>();
Budget budget = new Budget(month: 0, limit: 0.0);

double income = 0;

double expense = 0;

//ALl DISTINCT MONTHS
List<String> months = new List<String>();

///CURRENT MONTH
double monthIncome = 0.0;
double monthExpense = 0.0;

double monthTotal = monthIncome + monthExpense;


