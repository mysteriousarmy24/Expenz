import 'dart:convert';

import 'package:expenz/models/expenses_models.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpenseService {
  List<Expense> expensesList = [];
  //defineing key fo rstoring sharedPref
  static const String _expenseKey = 'expenses';
  //save the expenses in shared pref
  Future<void> saveExpenses(Expense expense, BuildContext context) async {
    try {
      //creating an instance
      SharedPreferences prefs = await SharedPreferences.getInstance();

      List<String>? exsitExpenses = prefs.getStringList(_expenseKey);

      //Convert the exsisting expenses to a list of Expenses
      List<Expense> existingExpenseObjects = [];
      if (exsitExpenses != null) {
        existingExpenseObjects = exsitExpenses
            .map((e) => Expense.fromJSON(json.decode(e)))
            .toList();
      }
      //add new expense to the list
      existingExpenseObjects.add(expense);
      //convert the list of obj baack to list of strings
      List<String> updatedExpenses = existingExpenseObjects
          .map((e) => json.encode(e.toJson()))
          .toList();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Expenses adding succesfully...")),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error...")));
      }
    }
  }
  //load data from shared pref
  Future <List<Expense>> loadExpense() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    List <String>? existingExpenses = pref.getStringList(_expenseKey);
    //converting existing expenses to a list of obj
    List <Expense> loadedExpenses = [];
    if(existingExpenses!=null){
      loadedExpenses = existingExpenses.map((e)=>Expense.fromJSON(json.decode(e))).toList();
    }
    return loadedExpenses;
  }
}
