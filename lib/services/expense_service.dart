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

      List<String>? existingExpenses = prefs.getStringList(_expenseKey);

      //Convert the exsisting expenses to a list of Expenses
      List<Expense> existingExpenseObjects = [];
      if (existingExpenses != null) {
        existingExpenseObjects = existingExpenses
            .map((e) => Expense.fromJSON(json.decode(e)))
            .toList();
      }
      //add new expense to the list
      existingExpenseObjects.add(expense);
      //convert the list of obj baack to list of strings
      List<String> updatedExpenses = existingExpenseObjects
          .map((e) => json.encode(e.toJson()))
          .toList();
      // Save the updated list of expenses to shared preferences
      await prefs.setStringList(_expenseKey, updatedExpenses);

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
  Future<List<Expense>> loadExpense() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? existingExpenses = pref.getStringList(_expenseKey);
    //converting existing expenses to a list of obj
    List<Expense> loadedExpenses = [];
    if (existingExpenses != null) {
      loadedExpenses = existingExpenses
          .map((e) => Expense.fromJSON(json.decode(e)))
          .toList();
    }
    return loadedExpenses;
  }

  Future<void> deleteExpenses(int id, BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      List<String>? existingExpenses = pref.getStringList(_expenseKey);
      List<Expense> existingExpensesObj = [];
      if (existingExpenses != null) {
        existingExpensesObj = existingExpenses
            .map((e) => Expense.fromJSON(json.decode(e)))
            .toList();
      }

      // Remove the expense with the specified id from the list
      existingExpensesObj.removeWhere((expense) => expense.id == id);

      // Convert the list of Expense objects back to a list of strings
      List<String> updatedExpenses = existingExpensesObj
          .map((e) => json.encode(e.toJson()))
          .toList();

      // Save the updated list of expenses to shared preferences
      await pref.setStringList(_expenseKey, updatedExpenses);
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Expense deleted successfully"),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error...")));
      }
    }
  }

  //deleting when logout
  Future <void> deleAllExpenses(BuildContext contex)async{
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove(_expenseKey);

      if(contex.mounted){
        ScaffoldMessenger.of(contex).showSnackBar(
          SnackBar(content: Text("All expenses Deleted"))
        );
      }
    }catch(err){
      ScaffoldMessenger.of(contex).showSnackBar(
          SnackBar(content: Text("erro"))
        );

    }
  }
}
