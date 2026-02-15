import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  // Method to store shared preferences
  static Future<void> storeUserData({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      // Check if password and confirmPassword match
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password & Confirm Password do not match..."),
          ),
        );
        return;
        // Exit early if mismatch
      }

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("username", userName);
      await pref.setString("email", email);
      await pref.setString(
        "password",
        password,
      ); // Optional: store password if needed

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Data stored successfully...")));
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error storing data: ${err.toString()}")),
      );
    }
  }

  //method to check that details are saved
  static Future<bool> checkUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userName = pref.getString('username');
    return userName != null;
  }

  //get the username & password
  static Future <Map <String,String>> getUserData() async{
    //creating an  instance
    SharedPreferences prefs =await SharedPreferences.getInstance();
    String? userName = prefs.getString("username");
    String? email = prefs.getString("email");
    return {"username":userName!,"email":email!};
  }
  Future <void> removeDetails()async{
    SharedPreferences prefs =await SharedPreferences.getInstance();
    prefs.remove("username");
    prefs.remove("password");
    prefs.remove("email");
  }

  // Store onboarding data
  static Future<void> storeOnboardingData({
    required String primaryBankAccount,
    required double startingBalance,
    required DateTime onboardingDate,
  }) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("primaryBankAccount", primaryBankAccount);
      await pref.setDouble("startingBalance", startingBalance);
      await pref.setString("onboardingDate", onboardingDate.toIso8601String());
      await pref.setDouble("totalBalance", startingBalance); // totalBalance initialized with starting balance
    } catch (err) {
      throw Exception("Error storing onboarding data: ${err.toString()}");
    }
  }

  // Get onboarding data
  static Future<Map<String, dynamic>> getOnboardingData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      return {
        "primaryBankAccount": pref.getString("primaryBankAccount"),
        "startingBalance": pref.getDouble("startingBalance"),
        "onboardingDate": pref.getString("onboardingDate") != null
            ? DateTime.parse(pref.getString("onboardingDate")!)
            : null,
        "totalBalance": pref.getDouble("totalBalance"),
      };
    } catch (err) {
      throw Exception("Error retrieving onboarding data: ${err.toString()}");
    }
  }

  // Check if onboarding is complete
  static Future<bool> isOnboardingComplete() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? primaryBankAccount = pref.getString("primaryBankAccount");
    return primaryBankAccount != null;
  }

  // Update total balance
  static Future<void> updateTotalBalance(double newBalance) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setDouble("totalBalance", newBalance);
    } catch (err) {
      throw Exception("Error updating total balance: ${err.toString()}");
    }
  }

  // Get total balance
  static Future<double> getTotalBalance() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      return pref.getDouble("totalBalance") ?? 0.0;
    } catch (err) {
      throw Exception("Error retrieving total balance: ${err.toString()}");
    }
  }

  // Save monthly expenses (list of 12 values for each month)
  static Future<void> saveMonthlyExpenses(List<double> monthlyExpenses) async {
    try {
      if (monthlyExpenses.length != 12) {
        throw Exception("Monthly expenses list must have exactly 12 values");
      }
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setStringList(
        "monthlyExpenses",
        monthlyExpenses.map((e) => e.toString()).toList(),
      );
    } catch (err) {
      throw Exception("Error saving monthly expenses: ${err.toString()}");
    }
  }

  // Get monthly expenses
  static Future<List<double>?> getMonthlyExpenses() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      List<String>? expensesStr = pref.getStringList("monthlyExpenses");
      if (expensesStr == null) {
        return null;
      }
      return expensesStr.map((e) => double.parse(e)).toList();
    } catch (err) {
      throw Exception("Error retrieving monthly expenses: ${err.toString()}");
    }
  }

  // Set last archive date
  static Future<void> setLastArchiveDate(DateTime lastArchiveDate) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("lastArchiveDate", lastArchiveDate.toIso8601String());
    } catch (err) {
      throw Exception("Error setting last archive date: ${err.toString()}");
    }
  }

  // Get last archive date
  static Future<DateTime?> getLastArchiveDate() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? lastArchiveDateStr = pref.getString("lastArchiveDate");
      if (lastArchiveDateStr == null) {
        return null;
      }
      return DateTime.parse(lastArchiveDateStr);
    } catch (err) {
      throw Exception("Error retrieving last archive date: ${err.toString()}");
    }
  }
}
