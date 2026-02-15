import 'package:expenz/Screens/addnew_screen.dart';
import 'package:expenz/Screens/budget_screen.dart';
import 'package:expenz/Screens/home_screen.dart';
import 'package:expenz/Screens/profile_screen.dart';
import 'package:expenz/Screens/transition_screen.dart';
import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/models/income_category_model.dart';
import 'package:expenz/services/expense_service.dart';
import 'package:expenz/services/income_services.dart';
import 'package:expenz/services/transaction_simulator.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/main.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _curruntIndex=0;
  double? _preFillAmount;
  String? _preFillType;
  double _totalBalance = 0.0;

  List <Expense> expenseList =[];

  void fetchAllExpenses ()async{
    List <Expense>loadedExpenses = await ExpenseService().loadExpense();
    setState(() {
      expenseList =loadedExpenses;
    });
  }
  List <Income> incomeList=[];

  void fetchAllIncomes() async{
    List<Income>loadIncomes=await IncomeServices().loadIncome();
    setState(() {
      incomeList=loadIncomes;
    });
  }
  
  @override
  void initState() {
    super.initState();
    setState(() {
      fetchAllExpenses();
    });
    setState(() {
      fetchAllIncomes();
    });

    // Load totalBalance
    UserServices.getTotalBalance().then((balance) {
      setState(() {
        _totalBalance = balance;
      });
    });
    
    // Set up notification tap handler
    setNotificationNavigationCallback((payload) {
      _handleNotificationTap(payload);
    });
  }
  
  void _handleNotificationTap(String? payload) {
    if (payload != null) {
      try {
        final data = TransactionSimulator.parsePayload(payload);
        final amount = data['amount'] as double;
        final type = data['type'] as String;
        
        setState(() {
          _preFillAmount = amount;
          _preFillType = type;
          _curruntIndex = 2; // Index of AddnewScreen
        });
        
        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Detected: LKR ${amount.toStringAsFixed(2)} $type'),
            duration: Duration(seconds: 2),
          ),
        );
      } catch (err) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing notification: ${err.toString()}'),
          ),
        );
      }
    }
  }
  //add new expense
  void addNewExpenses(Expense newExpense){
    ExpenseService().saveExpenses(newExpense, context);

    //update the list of expenses and balance
    setState(() {
      expenseList.add(newExpense);
      _totalBalance -= newExpense.amount;
    });
    // Update balance in SharedPreferences
    UserServices.updateTotalBalance(_totalBalance);
  }
  //add new income
  void addNewIncomes(Income newIncome){
    IncomeServices().saveIncomes(newIncome, context);

    //update the list of incomes and balance
    setState(() {
      incomeList.add(newIncome);
      _totalBalance += newIncome.amount;
    });
    // Update balance in SharedPreferences
    UserServices.updateTotalBalance(_totalBalance);
  }
  void removeExpense(Expense expense){
    ExpenseService().deleteExpenses(expense.id, context);
    setState(() {
      expenseList.remove(expense);
      _totalBalance += expense.amount;
    });
    // Update balance in SharedPreferences
    UserServices.updateTotalBalance(_totalBalance);
  }
  void deleteIncome(Income income){
    IncomeServices().removeIncome(income.id, context);
    setState(() {
      incomeList.remove(income);
      _totalBalance -= income.amount;
    });
    // Update balance in SharedPreferences
    UserServices.updateTotalBalance(_totalBalance);
  }
  Map<ExpenseCategory,double>calculateExpenseTotal(){
    Map<ExpenseCategory,double>expenseCategoryTot={
      ExpenseCategory.food:0,
      ExpenseCategory.transport:0,
      ExpenseCategory.health:0,
      ExpenseCategory.shopping:0,
      ExpenseCategory.subscription:0,
      ExpenseCategory.others:0,
      
    };
      for(Expense expense in expenseList){
        expenseCategoryTot[expense.category] =expenseCategoryTot[expense.category]! + expense.amount  ;


      }
      return expenseCategoryTot;

    
  }

  double calculateTotalExpenseAmount() {
    double total = 0.0;
    for (Expense expense in expenseList) {
      total += expense.amount;
    }
    return total;
  }

  Map<IncomeCategory,double>calculateIncomesTotal(){
    Map<IncomeCategory,double>incomeCategoryTot={
      IncomeCategory.freelance:0,
      IncomeCategory.passive:0,
      IncomeCategory.sales:0,
      IncomeCategory.salary:0,
      IncomeCategory.others:0,
  
    };
      for(Income income in incomeList){
        incomeCategoryTot[income.category] =incomeCategoryTot[income.category]! + income.amount  ;


      }
      return incomeCategoryTot;

    
  }
  @override
  Widget build(BuildContext context) {
    final List <Widget> screenList = [
      
      
      

      HomeScreen(
        incomesList: incomeList,
        expensesList: expenseList,
      ),
      TransitionScreen(
        addDissmissIncome: deleteIncome,
        incomesList: incomeList,
        addDissmissExpense:removeExpense ,
        expensesList: expenseList,
      ),
      AddnewScreen(
        addIncome:addNewIncomes ,
        addExpense: addNewExpenses,
        preFillAmount: _preFillAmount,
        preFillType: _preFillType,
      ),
      BudgetScreen(
        expensesTotal:calculateExpenseTotal() ,
        incomesTotal: calculateIncomesTotal(),
      ),
      ProfileScreen(
        expensesList: expenseList,
        totalBalance: _totalBalance,
      ),
      
      
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: kWhite,
        selectedItemColor: kMainColor,
        unselectedItemColor: kGrey,
        currentIndex: _curruntIndex,
        selectedLabelStyle: TextStyle(
          fontSize:12,
          fontWeight:FontWeight.w600
        ),

        onTap: (index) {
          setState(() {
            _curruntIndex=index;
          });
        },
        
        items: [
          BottomNavigationBarItem(
            label: "Home",
          icon: Icon(
            Icons.home,
            
            ),
            ),

            BottomNavigationBarItem(
            label: "Transactions",
          icon: Icon(
            Icons.list_rounded,
            
            ),
            ),
            BottomNavigationBarItem(
              label: "",
          icon: Container(
            
            decoration: BoxDecoration(
              color: kMainColor,
              shape: BoxShape.circle,
              
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Icon(
                Icons.add,
                color: kWhite,
                
                ),
            ),
          ),
            ),
            BottomNavigationBarItem(
            label: "Budget",
          icon: Icon(
            Icons.rocket,
            
            ),
            ),

            BottomNavigationBarItem(
            label: "Profile",
          icon: Icon(
            Icons.person,
            
            ),
            ),
            ],
      ),
      body: screenList[_curruntIndex],
    );
  }
}
