import 'package:expenz/Screens/main_screen.dart';
import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/Screens/user_data_screen.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:expenz/widgets/expenses_card.dart';
import 'package:expenz/widgets/income_expences_widget.dart';
import 'package:expenz/widgets/line_chart_sample.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final List<Income> incomesList;
  final List<Expense> expensesList;
  const HomeScreen({
    super.key,
    required this.incomesList,
    required this.expensesList,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String username = "";
  @override
  void initState() {
    UserServices.getUserData().then((value) {
      if (value["username"] != null) {
        setState(() {
          username = value["username"]!;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //col with bg color
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: BoxDecoration(
                color: kMainColor.withOpacity(0.37),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(kDefalutPadding),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: kMainColor.withOpacity(0.2), width: 5),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(100),
                            child: Image.asset(
                              "assets/images/person.png",
                              fit: BoxFit.cover,
                              width: 60,
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Text(
                            "Welcome! $username",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.notifications,
                            color: kMainColor,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IncomeExpencesWidget(
                          isIncome: true,
                          value:
                              "LKR\n${widget.incomesList.fold(0.0, (sum, item) => sum + item.amount)}",
                        ),
                        IncomeExpencesWidget(
                          isIncome: false,
                          value:
                              "LKR\n${widget.expensesList.fold(0.0, (sum, item) => sum + item.amount)}",
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Spend frequency",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  LineChartSample(),
                  SizedBox(height: 15),
                  Text(
                    "Recent Transaction",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  widget.expensesList.isEmpty
                      ? Text(
                          "No expenses yet,please add some expenses...",
                          style: TextStyle(
                            color: kGrey,
                            fontSize: 16
                          ),
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
                                    return ExpenceCard(
                                      title: expense.title,
                                      description: expense.description,
                                      amount: expense.amount,
                                      time: expense.date,
                                      date: expense.time,
                                      category: expense.category,
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
          ],
        ),
      ),
    );
  }
}
