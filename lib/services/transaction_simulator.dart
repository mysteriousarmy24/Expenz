import 'package:expenz/services/user_services.dart';
import 'package:expenz/services/notification_service.dart';

class TransactionSimulator {
  static final TransactionSimulator _instance = TransactionSimulator._internal();

  factory TransactionSimulator() {
    return _instance;
  }

  TransactionSimulator._internal();

  /// Simulates detecting a transaction and updates the balance
  /// Returns transaction payload for notification tap
  Future<String> simulateTransaction({
    required double amount,
    required String type, // "Income" or "Expense"
  }) async {
    try {
      // Get current onboarding data
      final onboardingData = await UserServices.getOnboardingData();
      final currentBalance = onboardingData["totalBalance"] as double? ?? 0.0;
      final primaryBank = onboardingData["primaryBankAccount"] as String?;

      if (primaryBank == null) {
        throw Exception("Primary bank account not set. Please complete onboarding.");
      }

      // Calculate new balance
      double newBalance = currentBalance;
      if (type.toLowerCase() == 'income') {
        newBalance += amount;
      } else if (type.toLowerCase() == 'expense') {
        newBalance -= amount;
      } else {
        throw Exception("Invalid transaction type. Use 'Income' or 'Expense'");
      }

      // Ensure balance doesn't go negative (optional validation)
      if (newBalance < 0) {
        throw Exception("Insufficient balance. Transaction cannot be completed.");
      }

      // Update the totalBalance in SharedPreferences
      await UserServices.updateTotalBalance(newBalance);

      // Create payload for notification tap
      final payload = _createPayload(amount: amount, type: type);

      // Show notification
      await NotificationService().showTransactionNotification(
        amount: amount,
        type: type,
        bankAccount: primaryBank,
        payload: payload,
      );

      return payload;
    } catch (err) {
      throw Exception("Error simulating transaction: ${err.toString()}");
    }
  }

  /// Creates JSON payload for notification tap
  /// This payload will be used to pre-fill the AddnewScreen
  String _createPayload({
    required double amount,
    required String type,
  }) {
    return '$amount|$type';
  }

  /// Parses payload from notification tap
  /// Returns {amount: double, type: String}
  static Map<String, dynamic> parsePayload(String payload) {
    final parts = payload.split('|');
    return {
      'amount': double.parse(parts[0]),
      'type': parts[1],
    };
  }

  /// Simulate multiple random transactions (useful for testing)
  Future<void> simulateRandomTransactions({
    int count = 3,
    required Function(String) onTransactionSimulated,
  }) async {
    final List<Map<String, dynamic>> transactions = [
      {'amount': 500.0, 'type': 'Expense', 'name': 'Coffee'},
      {'amount': 1200.0, 'type': 'Expense', 'name': 'Lunch'},
      {'amount': 5000.0, 'type': 'Income', 'name': 'Freelance'},
      {'amount': 250.0, 'type': 'Expense', 'name': 'Gas'},
      {'amount': 2000.0, 'type': 'Income', 'name': 'Bonus'},
      {'amount': 1500.0, 'type': 'Expense', 'name': 'Shopping'},
    ];

    for (int i = 0; i < count && i < transactions.length; i++) {
      final transaction = transactions[i];
      try {
        await simulateTransaction(
          amount: transaction['amount'] as double,
          type: transaction['type'] as String,
        );
        onTransactionSimulated(transaction['name'] as String);
        
        // Small delay between transactions
        await Future.delayed(Duration(seconds: 2));
      } catch (err) {
        onTransactionSimulated('Error: ${err.toString()}');
      }
    }
  }
}
