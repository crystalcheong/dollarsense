import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../shared/theme.dart';
import '../../data/globals.dart' as globals;
import '../../data/categories.dart' as categories;

class RadialChart extends StatelessWidget {

  final String month;
  RadialChart(this.month);
  
  @override
  Widget build(BuildContext context) {

    bool hasExpense = false;

    Map<String, double> categoryExpense = new Map();

    var categoryList = categories.categories["expense"].entries.toList();
    for(var entry in categoryList){
      var title = entry.key;
      categoryExpense.putIfAbsent(title, () => (globals.transactions.where((t) => t.type == "expense" && DateFormat.MMMM().format(t.date) == month && t.title == title).toList()).fold(0, (i, j) => i + j.amount));

      if(categoryExpense[title] > 0){
        hasExpense = true;
      }
    }
    print(categoryExpense['Food']);

    return (!hasExpense)
    ? Container(
      child: Text("Expenditure analysis is not available"),
    )

    : Container(
      child: PieChart(
        dataMap: categoryExpense,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32.0,
        chartRadius: MediaQuery.of(context).size.width / 2.7,
        showChartValuesInPercentage: true,
        showChartValues: true,
        showChartValuesOutside: false,
        chartValueBackgroundColor: Colors.transparent,
        colorList: [
          kLightPrimary,
          kPrimary,
          kDarkPrimary,

          kLightSecondary,
          kSecondary,
          kDarkSecondary
        ],
        showLegends: true,
        legendPosition: LegendPosition.left,
        legendStyle: TextStyle(color: Colors.black),
        decimalPlaces: 1,
        showChartValueLabel: true,
        initialAngle: 0,
        chartValueStyle: defaultChartValueStyle.copyWith(
          color: Colors.white,
        ),
        chartType: ChartType.disc,
      )
    );
  }
}
