import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/services/expense_service.dart';
import 'package:expenz/services/user_services.dart';
// For FlSpot import
import 'package:fl_chart/fl_chart.dart';

class MonthlyArchiveService {
  static final MonthlyArchiveService _instance = MonthlyArchiveService._internal();

  factory MonthlyArchiveService() {
    return _instance;
  }

  MonthlyArchiveService._internal();

  /// Archive monthly expenses and update balance
  /// This function:
  /// 1. Calculates sum of all expenses from the past 30 days
  /// 2. Saves this sum to a list of 12 monthly values
  /// 3. Clears individual transaction records for the archived month
  Future<void> archiveMonthlyExpenses() async {
    try {
      // Get onboarding date to calculate 30-day cycles
      final onboardingData = await UserServices.getOnboardingData();
      final onboardingDate = onboardingData['onboardingDate'] as DateTime?;

      if (onboardingDate == null) {
        throw Exception('Onboarding date not found');
      }

      // Get all expenses
      final allExpenses = await ExpenseService().loadExpense();

      // Calculate the current month index (0-11 for Jan-Dec)
      final now = DateTime.now();
      final monthIndex = now.month - 1; // 0-based month

      // Get expenses from the past 30 days (or since onboarding if within 30 days)
      final thirtyDaysAgo = now.subtract(Duration(days: 30));
      final recentExpenses = allExpenses.where((expense) {
        return expense.date.isAfter(thirtyDaysAgo) &&
            expense.date.isBefore(now.add(Duration(days: 1)));
      }).toList();

      // Calculate total expenses for the month
      double monthlyTotal = 0.0;
      for (var expense in recentExpenses) {
        monthlyTotal += expense.amount;
      }

      // Load existing monthly data
      List<double> monthlyExpenses =
          await UserServices.getMonthlyExpenses() ?? List<double>.filled(12, 0.0);

      // Update the current month with the calculated total
      monthlyExpenses[monthIndex] = monthlyTotal;

      // Save the updated monthly expenses
      await UserServices.saveMonthlyExpenses(monthlyExpenses);

      // Clear individual transactions (optional - can be disabled if you want to keep history)
      // await _clearMonthlyTransactions(recentExpenses);

      print('Monthly archive completed for month $monthIndex: LKR$monthlyTotal');
    } catch (err) {
      throw Exception('Error archiving monthly expenses: ${err.toString()}');
    }
  }

  /// Get monthly expenses for the year
  Future<List<double>> getMonthlyExpenses() async {
    try {
      return await UserServices.getMonthlyExpenses() ??
          List<double>.filled(12, 0.0);
    } catch (err) {
      throw Exception('Error retrieving monthly expenses: ${err.toString()}');
    }
  }

  /// Get monthly expenses for a specific month
  Future<double> getMonthExpense(int monthIndex) async {
    try {
      if (monthIndex < 0 || monthIndex > 11) {
        throw Exception('Invalid month index. Must be between 0-11');
      }
      final monthlyExpenses = await getMonthlyExpenses();
      return monthlyExpenses[monthIndex];
    } catch (err) {
      throw Exception('Error retrieving month expense: ${err.toString()}');
    }
  }

  /// Set monthly expenses manually (for user input during onboarding)
  Future<void> setMonthlyExpenses(List<double> expenses) async {
    try {
      if (expenses.length != 12) {
        throw Exception('Monthly expenses list must have exactly 12 values');
      }

      // Validate all values are non-negative
      for (var expense in expenses) {
        if (expense < 0) {
          throw Exception('Monthly expenses cannot be negative');
        }
      }

      await UserServices.saveMonthlyExpenses(expenses);
      print('Monthly expenses updated successfully');
    } catch (err) {
      throw Exception('Error setting monthly expenses: ${err.toString()}');
    }
  }

  /// Check if monthly archive is due (more than 30 days since last archive or onboarding)
  Future<bool> isMonthlyArchiveDue() async {
    try {
      final onboardingData = await UserServices.getOnboardingData();
      final onboardingDate = onboardingData['onboardingDate'] as DateTime?;

      if (onboardingDate == null) {
        return false;
      }

      final lastArchiveDate = await UserServices.getLastArchiveDate();

      if (lastArchiveDate == null) {
        // First archive, check if 30 days have passed since onboarding
        final thirtyDaysAfterOnboarding = onboardingDate.add(Duration(days: 30));
        return DateTime.now().isAfter(thirtyDaysAfterOnboarding);
      }

      // Check if 30 days have passed since last archive
      final thirtyDaysAfterLastArchive = lastArchiveDate.add(Duration(days: 30));
      return DateTime.now().isAfter(thirtyDaysAfterLastArchive);
    } catch (err) {
      print('Error checking archive due: ${err.toString()}');
      return false;
    }
  }

  /// Get the next archive date
  Future<DateTime?> getNextArchiveDate() async {
    try {
      final lastArchiveDate = await UserServices.getLastArchiveDate();

      if (lastArchiveDate == null) {
        final onboardingData = await UserServices.getOnboardingData();
        final onboardingDate = onboardingData['onboardingDate'] as DateTime?;
        if (onboardingDate != null) {
          return onboardingDate.add(Duration(days: 30));
        }
        return null;
      }

      return lastArchiveDate.add(Duration(days: 30));
    } catch (err) {
      print('Error getting next archive date: ${err.toString()}');
      return null;
    }
  }

  /// Mark the current time as the last archive
  Future<void> markArchiveComplete() async {
    try {
      await UserServices.setLastArchiveDate(DateTime.now());
    } catch (err) {
      throw Exception('Error marking archive complete: ${err.toString()}');
    }
  }

  /// Get month name from index
  static String getMonthName(int monthIndex) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    if (monthIndex < 0 || monthIndex > 11) {
      return 'Invalid';
    }
    return months[monthIndex];
  }

  /// Get month abbreviation from index
  static String getMonthAbbr(int monthIndex) {
    const abbrs = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    if (monthIndex < 0 || monthIndex > 11) {
      return 'N/A';
    }
    return abbrs[monthIndex];
  }

  /// Convert monthly expenses to FlSpot format for charts
  List<FlSpot> getMonthlyExpensesAsFlSpots(List<double> monthlyExpenses) {
    List<FlSpot> spots = [];
    for (int i = 0; i < monthlyExpenses.length; i++) {
      spots.add(FlSpot(i.toDouble(), monthlyExpenses[i]));
    }
    return spots;
  }

  /// Get max value from monthly expenses (useful for chart scaling)
  double getMaxMonthlyExpense(List<double> monthlyExpenses) {
    if (monthlyExpenses.isEmpty) return 0;
    return monthlyExpenses.reduce((a, b) => a > b ? a : b);
  }

  /// Get total annual expenses
  double getTotalAnnualExpenses(List<double> monthlyExpenses) {
    return monthlyExpenses.fold(0.0, (sum, value) => sum + value);
  }

  /// Get average monthly expense
  double getAverageMonthlyExpense(
      List<double> monthlyExpenses, int monthsWithData) {
    if (monthsWithData <= 0) return 0;
    final total = getTotalAnnualExpenses(monthlyExpenses);
    return total / monthsWithData;
  }
}


