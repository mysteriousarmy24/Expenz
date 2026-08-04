import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/number_formatter.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final Map<ExpenseCategory,double>expenseTotal;
  final Map<IncomeCategory,double>incomeTotal;
   final bool isIncome;
  const Chart({super.key,required this.expenseTotal,required this.incomeTotal, required this.isIncome});

  //sectiondata
  List<PieChartSectionData>getChartSection(){

    

    

    if(isIncome){
      return[
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.food],
          radius: 60,
          showTitle: false,
          value: expenseTotal[ExpenseCategory.food]??0
        ),
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.transport],
          radius: 60,
          showTitle: false,
          value: expenseTotal[ExpenseCategory.transport]??0
        ),
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.subscription],
          radius: 60,
          showTitle: false,
          value: expenseTotal[ExpenseCategory.subscription]??0
        ),
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.shopping],
          radius: 60,
          showTitle: false,
          value: expenseTotal[ExpenseCategory.shopping]??0
        ),
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.health],
          radius: 60,
          showTitle: false,
          value: expenseTotal[ExpenseCategory.health]??0
        ),
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.others],
          radius: 60,
          showTitle: false,
          value: expenseTotal[ExpenseCategory.others]??0
        ),
      ];
    }else{
      return[
        PieChartSectionData(
          color: incomeCategoryColors[IncomeCategory.freelance],
          value: incomeTotal[IncomeCategory.freelance]??0,
          radius: 60,
          showTitle: false
        ),
        PieChartSectionData(
          color: incomeCategoryColors[IncomeCategory.passive],
          value: incomeTotal[IncomeCategory.passive]??0,
          radius: 60,
          showTitle: false
        ),PieChartSectionData(
          color: incomeCategoryColors[IncomeCategory.salary],
          value: incomeTotal[IncomeCategory.salary]??0,
          radius: 60,
          showTitle: false
        ),PieChartSectionData(
          color: incomeCategoryColors[IncomeCategory.sales],
          value: incomeTotal[IncomeCategory.sales]??0,
          radius: 60,
          showTitle: false
        ),
        PieChartSectionData(
          color: incomeCategoryColors[IncomeCategory.others],
          value: incomeTotal[IncomeCategory.others]??0,
          radius: 60,
          showTitle: false
        ),
      ];
    }
  }
  @override
  Widget build(BuildContext context) {
    final PieChartData pieChartData=PieChartData(
      sections: getChartSection(),
      centerSpaceRadius: 70,
      sectionsSpace: 0,
      startDegreeOffset: -90,
      borderData: FlBorderData(show: false)
    );
    final total = isIncome ? expenseTotal.values.fold(0.0, (sum, value) => sum + value) : incomeTotal.values.fold(0.0, (sum, value) => sum + value);
    if (total <= 0) return const Center(child: Text('Please add expenses or incomes.'));
    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.maxWidth.clamp(180.0, 280.0).toDouble();
      return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kWhite
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: PieChart(
              pieChartData
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isIncome ? Center(
                child: Text("LKR\n${formatCurrencyAmount(total)}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(
                  fontSize: size * .1,
                  fontWeight: FontWeight.bold
                ),),
              )
              :Center(
                child: Text("LKR\n${formatCurrencyAmount(total)}", textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(
                  fontSize: size * .1,
                  fontWeight: FontWeight.bold
                ),),
              )

            ],
          )
        ],
      ),
    );
    });
  }
}
//values.fold(0.0, (sum,element)=>sum+element)
