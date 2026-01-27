import 'package:flutter/material.dart';

enum IncomeCategory { 
  freelance, 
  salary, 
  passive, 
  sales 
}

//category images
final Map<IncomeCategory, String> incomeCategoryImages = {
  IncomeCategory.freelance: "assets/images/freelance.png",
  IncomeCategory.passive: "assets/images/passive.png",
  IncomeCategory.salary: "assets/mages/salary.png",
  IncomeCategory.sales: "assets/images/sales.png",
};
//category colors
final Map<IncomeCategory, Color> incomeCategoryColors = {
  IncomeCategory.freelance: const Color(0xFFE57373),
  IncomeCategory.passive: const Color(0xFF81C784),
  IncomeCategory.sales: const Color(0xFF64B5F6),
  IncomeCategory.salary: const Color(0xFFFFD54F),
};

class Income {
  final int id;
  final String title;
  final double amount;
  final IncomeCategory category;
  final DateTime date;
  final DateTime time;
  final String description;

  Income({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.time,
    required this.description,
  });
  //JSON serialization
  Map<String,dynamic>toJson(){
    return{
      'id':id,
      'title':title,
      'amount':amount,
      'description':description,
      'category':category.index,
      'date':date.toIso8601String(),
      'time':time.toIso8601String(),
    };
  }
  //JSON deserialization
  factory Income.fromJSON(Map <String,dynamic> data){
    return Income(
      id: data['id'], 
      title: data['title'], 
      amount: data['amount'], 
      category: IncomeCategory.values[data['category']], 
      date: DateTime.parse(data['date']), 
      time: DateTime.parse(data['time']), 
      description: data['description']
      );
  }

}
