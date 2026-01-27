import 'package:expenz/Screens/addnew_screen.dart';
import 'package:expenz/Screens/budget_screen.dart';
import 'package:expenz/Screens/home_screen.dart';
import 'package:expenz/Screens/profile_screen.dart';
import 'package:expenz/Screens/transition_screen.dart';
import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/services/expense_service.dart';
import 'package:expenz/utilities/colors.dart';

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _curruntIndex=0;

  List <Expense> expenseList =[];

  void fetchAllExpenses ()async{
    List <Expense>loadedExpenses = await ExpenseService().loadExpense();
    setState(() {
      expenseList =loadedExpenses;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      fetchAllExpenses();
});
  }
  //add new expense
  void addNewExpenses(Expense newExpense){
    ExpenseService().saveExpenses(newExpense, context);

    //update the list of expenses
    setState(() {
      expenseList.add(newExpense);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final List <Widget> screenList = [

      HomeScreen(),
      TransitionScreen(),
      AddnewScreen(
        addExpense: addNewExpenses,
      ),
      BudgetScreen(),
      ProfileScreen()
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
