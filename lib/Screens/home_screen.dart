import 'package:expenz/Screens/main_screen.dart';
import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/services/monthly_archive_service.dart';
import 'package:expenz/Screens/user_data_screen.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:expenz/utilities/number_formatter.dart';
import 'package:expenz/widgets/expenses_card.dart';
import 'package:expenz/widgets/income_expences_widget.dart';
import 'package:expenz/widgets/line_chart_sample.dart';
import 'package:expenz/utilities/responsive.dart';
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
  List<double> monthlyExpenses = List<double>.filled(12, 0.0);
  bool isArchiveDue = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _checkAndArchiveMonthly();
  }

  Future<void> _loadUserData() async {
    try {
      // Load monthly expenses
      final expenses = await UserServices.getMonthlyExpenses();
      if (expenses != null) {
        setState(() {
          monthlyExpenses = expenses;
        });
      }

      // Load username
      final userData = await UserServices.getUserData();
      if (userData["username"] != null) {
        setState(() {
          username = userData["username"]!;
        });
      }
    } catch (err) {
      print('Error loading user data: $err');
    }
  }

  Future<void> _checkAndArchiveMonthly() async {
    try {
      final archiveService = MonthlyArchiveService();
      final isDue = await archiveService.isMonthlyArchiveDue();

      if (isDue) {
        // Show notification
        setState(() {
          isArchiveDue = true;
        });

        // Perform archive
        await archiveService.archiveMonthlyExpenses();
        await archiveService.markArchiveComplete();

        // Reload monthly data
        await _loadUserData();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Monthly archive completed! Chart updated.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (err) {
      print('Error checking archive: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: context.verticalGap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //col with bg color
            Container(
              decoration: BoxDecoration(
                color: kMainColor.withOpacity(0.37),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.horizontalPadding),
                child: Column(
                  children: [
                    SizedBox(height: context.verticalGap),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: kMainColor.withOpacity(0.2),
                              width: 5,
                            ),
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
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Welcome!\n$username",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
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
                    SizedBox(height: context.verticalGap),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final cardWidth = (constraints.maxWidth - 12) / 2;
                        return Row(
                          children: [
                            SizedBox(
                              width: cardWidth,
                              child: IncomeExpencesWidget(
                                isIncome: true,
                                value:
                                    "LKR\n${formatCurrencyAmount(widget.incomesList.fold(0.0, (sum, item) => sum + item.amount))}",
                              ),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                              width: cardWidth,
                              child: IncomeExpencesWidget(
                                isIncome: false,
                                value:
                                    "LKR\n${formatCurrencyAmount(widget.expensesList.fold(0.0, (sum, item) => sum + item.amount))}",
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.horizontalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.verticalGap),
                  Text(
                    "Spend frequency",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: context.verticalGap),
                  LineChartSample(monthlyExpenses: monthlyExpenses),
                  SizedBox(height: context.verticalGap),
                  Text(
                    "Recent Transaction",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: context.verticalGap),
                  widget.expensesList.isEmpty
                      ? Text(
                          "No expenses yet,please add some expenses...",
                          style: TextStyle(color: kGrey, fontSize: 16),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.expensesList.length,
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
          ],
        ),
      ),
    );
  }
}
