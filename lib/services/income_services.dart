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




}
