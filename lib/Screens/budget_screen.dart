import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/widgets/category_chart_card.dart';
import 'package:expenz/widgets/pie_chart.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  final Map<ExpenseCategory, double> expensesTotal;
  final Map<IncomeCategory, double> incomesTotal;

  const BudgetScreen({
    super.key,
    required this.expensesTotal,
    required this.incomesTotal,
  });

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

int _selectedMethod = 0;

Color getColor(dynamic category){
  if(category is ExpenseCategory){
    return expenseCategoryColors[category]!;
  }else{
    return incomeCategoryColors[category]!;
  }
}

class _BudgetScreenState extends State<BudgetScreen> {
  @override
  Widget build(BuildContext context) {
    final data = _selectedMethod == 0
        ? widget.expensesTotal
        : widget.incomesTotal;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Financial Report",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                    color: Color(0xFFF1F1FA),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  height: MediaQuery.of(context).size.height * 0.08,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMethod = 0;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedMethod == 0
                                  ? kRed
                                  : Color(0xFFF1F1FA),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                              child: Text(
                                "Expenses",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: _selectedMethod == 0
                                      ? Color(0xFFF1F1FA)
                                      : kBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMethod = 1;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: _selectedMethod == 1
                                  ? kGreen
                                  : Color(0xFFF1F1FA),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 15,
                              ),
                              child: Text(
                                "Incomes",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: _selectedMethod == 1
                                      ? Color(0xFFF1F1FA)
                                      : kBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Chart(
                isIncome: _selectedMethod == 0,
                expenseTotal: widget.expensesTotal,
                incomeTotal: widget.incomesTotal,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final category = data.keys.toList()[index];
                      final total = data.values.toList()[index];
                      return CategoryChartCard(
                        title: category.name,
                        progressColor: /*_selectedMethod == 0
                            ? incomeCategoryColors.values.toList()[index]
                            : expenseCategoryColors.values.toList()[index]*/
                            getColor(category),
                        amount: total,
                        total: data.values.fold(0.0, (sum,element)=>sum+element),
                        isExpense: _selectedMethod==0?true:false,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
