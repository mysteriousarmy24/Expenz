import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Chart extends StatefulWidget {
  final Map<ExpenseCategory,double>expenseTotal;
  final Map<IncomeCategory,double>incomeTotal;
   final bool isIncome;
  const Chart({super.key,required this.expenseTotal,required this.incomeTotal, required this.isIncome});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  //sectiondata
  List<PieChartSectionData>getChartSection(){
    if(widget.isIncome){
      return[
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.food],
          radius: 60,
          showTitle: false,
          value: widget.expenseTotal[ExpenseCategory.food]??0
        ),
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.transport],
          radius: 60,
          showTitle: false,
          value: widget.expenseTotal[ExpenseCategory.transport]??0
        ),
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.subscription],
          radius: 60,
          showTitle: false,
          value: widget.expenseTotal[ExpenseCategory.subscription]??0
        ),
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.shopping],
          radius: 60,
          showTitle: false,
          value: widget.expenseTotal[ExpenseCategory.shopping]??0
        ),
        PieChartSectionData(
          color: expenseCategoryColors[ExpenseCategory.health],
          radius: 60,
          showTitle: false,
          value: widget.expenseTotal[ExpenseCategory.health]??0
        ),
      ];
    }else{
      return[
        PieChartSectionData(
          color: incomeCategoryColors[IncomeCategory.freelance],
          value: widget.incomeTotal[IncomeCategory.freelance]??0,
          radius: 60,
          showTitle: false
        ),
        PieChartSectionData(
          color: incomeCategoryColors[IncomeCategory.passive],
          value: widget.incomeTotal[IncomeCategory.passive]??0,
          radius: 60,
          showTitle: false
        ),PieChartSectionData(
          color: incomeCategoryColors[IncomeCategory.salary],
          value: widget.incomeTotal[IncomeCategory.salary]??0,
          radius: 60,
          showTitle: false
        ),PieChartSectionData(
          color: incomeCategoryColors[IncomeCategory.sales],
          value: widget.incomeTotal[IncomeCategory.sales]??0,
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
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: kWhite
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            pieChartData
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isIncome? Center(
                child: Text("LKR3000",style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),),
              )
              :Center(
                child: Text("LKR5000",style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold
                ),),
              )

            ],
          )
        ],
      ),
    );
  }
}