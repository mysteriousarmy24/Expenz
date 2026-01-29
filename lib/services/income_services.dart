import 'dart:convert';

import 'package:expenz/models/income_category_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IncomeServices {
  List<Income> incomeList = [];
  //key
  static const String _incomeKey = 'incomes';
  //save incomes
  Future<void> saveIncomes(Income income, BuildContext context) async {
    try {
      //existing incomes<Stings>  to dart obj
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? existIncomes = prefs.getStringList(_incomeKey);
      List<Income> existingIncomeObjects = [];
      if (existIncomes != null) {
        existingIncomeObjects = existIncomes
            .map((e) => Income.fromJSON(json.decode(e)))
            .toList();
      }
      //adding new obj
      existingIncomeObjects.add(income);
      //final objs to string
      List<String> updatedIncomes = existingIncomeObjects
          .map((e) => json.encode(e.toJson()))
          .toList();

      await prefs.setStringList(_incomeKey, updatedIncomes);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Incomes adding succesfully..."),
            duration: Duration(seconds: 2),
          ),
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

  //load the shared prefs
  Future<List<Income>> loadIncome() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? existingIncomes = pref.getStringList(_incomeKey);
    //converting existing expenses to a list of obj
    List<Income> loadedIncomes = [];
    if (existingIncomes != null) {
      loadedIncomes = existingIncomes
          .map((e) => Income.fromJSON(json.decode(e)))
          .toList();
    }
    return loadedIncomes;
  }

  //remove incomes
  Future<void> removeIncome(int id, BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      List<String>? existingIncomes = pref.getStringList(_incomeKey);
      List<Income> existigIncomesObj = [];
      if (existingIncomes != null) {
        existigIncomesObj = existingIncomes
            .map((e) => Income.fromJSON(json.decode(e)))
            .toList();
      }
      // Remove the expense with the specified id from the list
      existigIncomesObj.removeWhere((income) => income.id == id);

      // Convert the list of Expense objects back to a list of strings
      List<String> updatedIncomes = existigIncomesObj
          .map((e) => json.encode(e.toJson()))
          .toList();
      // Save the updated list of expenses to shared preferences
      await pref.setStringList(_incomeKey, updatedIncomes);
      //show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Incomes deleted successfully"),
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
}
