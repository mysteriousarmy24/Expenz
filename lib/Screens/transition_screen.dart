import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/widgets/expenses_card.dart';
import 'package:expenz/widgets/income_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TransitionScreen extends StatefulWidget {
  final List<Expense> expensesList;
  final List<Income> incomesList;
  final void Function(Expense) addDissmissExpense;
  final void Function(Income) addDissmissIncome;
  const TransitionScreen({
    super.key,
    required this.expensesList,
    required this.addDissmissExpense,
    required this.incomesList,
    required this.addDissmissIncome,
  });

  @override
  State<TransitionScreen> createState() => _TransitionScreenState();
}

class _TransitionScreenState extends State<TransitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text("Transaction")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "See your financial report",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: kMainColor,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Expense',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              widget.expensesList.isEmpty
                  ? Text(
                      "No expenses yet,please add some expenses...",
                      style: TextStyle(color: kGrey, fontSize: 16),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.expensesList.length,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final expense = widget.expensesList[index];
                                return Dismissible(
                                  onDismissed: (direction) {
                                    setState(() {
                                      widget.addDissmissExpense(expense);
                                    });
                                  },
                                  key: ValueKey(expense),
                                  direction: DismissDirection.startToEnd,
                                  child: ExpenceCard(
                                    title: expense.title,
                                    description: expense.description,
                                    amount: expense.amount,
                                    time: expense.date,
                                    date: expense.time,
                                    category: expense.category,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: 20),
              Text(
                'Incomes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
               widget.incomesList.isEmpty
                      ? Text(
                          "No incomes yet,please add some incomes...",
                          style: TextStyle(
                            color: kGrey,
                            fontSize: 16
                          ),
                        )
                      : 

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //incomes
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.incomesList.length,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final income = widget.incomesList[index];
                          return Dismissible(
                            direction: DismissDirection.startToEnd,
                            key: ValueKey(income),
                            onDismissed: (direction) {
                              setState(() {
                                widget.addDissmissIncome(income);
                              });
                            },
                            child: IncomeCard(
                              title: income.title,
                              description: income.description,
                              amount: income.amount,
                              time: income.date,
                              date: income.time,
                              category: income.category,
                            ),
                          );
                        },
                      ),
                    ],
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
