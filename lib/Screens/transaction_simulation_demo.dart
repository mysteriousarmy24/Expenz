import 'package:expenz/services/transaction_simulator.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:flutter/material.dart';

class TransactionSimulationDemoScreen extends StatefulWidget {
  const TransactionSimulationDemoScreen({super.key});

  @override
  State<TransactionSimulationDemoScreen> createState() =>
      _TransactionSimulationDemoScreenState();
}

class _TransactionSimulationDemoScreenState
    extends State<TransactionSimulationDemoScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedType = 'Expense';
  bool _isLoading = false;
  String _statusMessage = '';
  double? _currentBalance;

  @override
  void initState() {
    super.initState();
    _loadCurrentBalance();
  }

  Future<void> _loadCurrentBalance() async {
    try {
      final balance = await UserServices.getTotalBalance();
      setState(() {
        _currentBalance = balance;
      });
    } catch (err) {
      setState(() {
        _statusMessage = 'Error loading balance: ${err.toString()}';
      });
    }
  }

  Future<void> _simulateTransaction() async {
    if (_amountController.text.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter an amount';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    try {
      final amount = double.parse(_amountController.text);
      await TransactionSimulator().simulateTransaction(
        amount: amount,
        type: _selectedType,
      );

      await _loadCurrentBalance();

      setState(() {
        _statusMessage =
            '✅ ${_selectedType} of ₹${amount.toStringAsFixed(2)} simulated successfully!';
        _amountController.clear();
      });
    } catch (err) {
      setState(() {
        _statusMessage = '❌ Error: ${err.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _simulateMultipleTransactions() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Simulating transactions...';
    });

    try {
      await TransactionSimulator().simulateRandomTransactions(
        count: 3,
        onTransactionSimulated: (name) {
          setState(() {
            _statusMessage = 'Simulated: $name';
          });
        },
      );

      await _loadCurrentBalance();

      setState(() {
        _statusMessage = '✅ All transactions simulated successfully!';
      });
    } catch (err) {
      setState(() {
        _statusMessage = '❌ Error: ${err.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Simulation Demo'),
        backgroundColor: kMainColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefalutPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [kMainColor, kMainColor.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${_currentBalance?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Manual Transaction Section
            const Text(
              'Simulate Single Transaction',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Amount Input
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: kLightGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  prefixIcon: const Icon(Icons.currency_rupee),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Transaction Type Selection
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = 'Expense'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedType == 'Expense'
                            ? Colors.red.withOpacity(0.2)
                            : Colors.grey[100],
                        border: Border.all(
                          color: _selectedType == 'Expense'
                              ? Colors.red
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '💸 Expense',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedType == 'Expense'
                              ? Colors.red
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = 'Income'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _selectedType == 'Income'
                            ? Colors.green.withOpacity(0.2)
                            : Colors.grey[100],
                        border: Border.all(
                          color: _selectedType == 'Income'
                              ? Colors.green
                              : Colors.grey[300]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '💰 Income',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _selectedType == 'Income'
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Simulate Transaction Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _simulateTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kMainColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: Colors.grey[400],
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Simulate Transaction',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            // Bulk Simulation Section
            const Text(
              'Demo Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _simulateMultipleTransactions,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Run 3 Random Transactions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900],
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 30),

            // Status Message
            if (_statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _statusMessage.startsWith('✅')
                      ? Colors.green[50]
                      : Colors.red[50],
                  border: Border.all(
                    color: _statusMessage.startsWith('✅')
                        ? Colors.green
                        : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage.startsWith('✅')
                        ? Colors.green[900]
                        : Colors.red[900],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            const SizedBox(height: 30),

            // Instructions Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border.all(color: Colors.blue[200]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '📝 How It Works:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Enter an amount and select transaction type\n'
                    '2. Tap "Simulate Transaction"\n'
                    '3. You\'ll receive a notification with the amount\n'
                    '4. Tap the notification to navigate to Add Transaction screen with pre-filled amount and type\n'
                    '5. Your balance updates automatically',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
