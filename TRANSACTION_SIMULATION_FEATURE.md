# Transaction Simulation & Notifications Feature

## Overview
This feature allows users to simulate detecting transactions (Income/Expense) that automatically:
1. Update the total balance
2. Trigger local notifications
3. Navigate to the Add Transaction screen with pre-filled amount and type

## Features

### 1. Real-time Transaction Simulation
- Simulate a single transaction with custom amount and type
- Run random demo transactions for testing
- Automatic balance updates based on transaction type

### 2. Local Notifications
- Uses `flutter_local_notifications` package
- Shows notification with transaction details
- Tap notification to navigate to Add Transaction screen
- Pre-fills amount and type for quick entry

### 3. Balance Management
- Tracks total balance with starting amount from onboarding
- Prevents negative balances
- Persists balance using SharedPreferences

## How It Works

### Simulation Flow
```
User initiates transaction simulation
    ↓
TransactionSimulator validates and processes
    ↓
Balance is updated in SharedPreferences
    ↓
Local notification is triggered
    ↓
User can tap notification to navigate
    ↓
AddnewScreen opens with pre-filled data
    ↓
User only needs to select Category
    ↓
Transaction is saved
```

### Key Components

#### 1. **NotificationService** (`lib/services/notification_service.dart`)
- Initializes flutter_local_notifications
- Handles notification permissions (Android 13+)
- Shows transaction notifications with payload

```dart
// Initialize in main()
NotificationService().initialize((payload) {
  // Handle notification tap
});

// Show notification
await NotificationService().showTransactionNotification(
  amount: 1000.0,
  type: 'Income',
  bankAccount: 'HDFC Bank',
  payload: '1000.0|Income',
);
```

#### 2. **TransactionSimulator** (`lib/services/transaction_simulator.dart`)
- Core transaction simulation logic
- Updates totalBalance based on transaction type
- Triggers notifications
- Parses notification payloads

```dart
// Simulate single transaction
await TransactionSimulator().simulateTransaction(
  amount: 500.0,
  type: 'Expense',
);

// Run multiple demo transactions
await TransactionSimulator().simulateRandomTransactions(
  count: 3,
  onTransactionSimulated: (name) {
    print('Simulated: $name');
  },
);
```

#### 3. **UserServices Updates** (`lib/services/user_services.dart`)
New methods for balance management:
- `updateTotalBalance(double newBalance)` - Updates balance
- `getTotalBalance()` - Retrieves current balance

#### 4. **AddnewScreen Updates** (`lib/Screens/addnew_screen.dart`)
Now accepts optional pre-fill parameters:
- `preFillAmount` - Pre-fills amount field
- `preFillType` - Pre-selects Expense/Income

```dart
AddnewScreen(
  addExpense: callback,
  addIncome: callback,
  preFillAmount: 500.0,
  preFillType: 'Expense',
)
```

#### 5. **MainScreen Integration** (`lib/Screens/main_screen.dart`)
- Handles notification tap callbacks
- Parses payload and extracts amount/type
- Navigates to AddnewScreen with pre-filled data
- Shows confirmation snackbar

#### 6. **Demo Screen** (`lib/Screens/transaction_simulation_demo.dart`)
Interactive testing screen with:
- Current balance display
- Single transaction simulation
- Random demo transactions (3)
- Status messages
- Instructions

## Usage Guide

### For Users
1. Navigate to the Transaction Simulation Demo screen
2. Enter an amount and select transaction type (Expense/Income)
3. Tap "Simulate Transaction"
4. You'll receive a notification with the amount
5. Tap the notification to navigate to Add Transaction screen
6. Select a category and save the transaction

### For Developers

#### Accessing Demo Screen
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => TransactionSimulationDemoScreen(),
  ),
);
```

#### Programmatic Simulation
```dart
// Single transaction
try {
  await TransactionSimulator().simulateTransaction(
    amount: 1000.0,
    type: 'Income',
  );
} catch (err) {
  print('Error: $err');
}

// Multiple transactions
await TransactionSimulator().simulateRandomTransactions(
  count: 5,
  onTransactionSimulated: (name) {
    print('Completed: $name');
  },
);
```

## Error Handling

The system handles several error cases:
1. **No primary bank account** - User must complete onboarding first
2. **Invalid transaction type** - Only "Income" or "Expense" allowed
3. **Negative balance** - Transaction is prevented if it would result in negative balance
4. **Notification permission denied** - Gracefully handled on Android 13+

## Notification Payload Format

The notification payload uses a simple pipe-delimited format:
```
amount|type
Example: 1000.0|Income
```

This is parsed by `TransactionSimulator.parsePayload()`:
```dart
final data = TransactionSimulator.parsePayload('1000.0|Income');
// Returns: {amount: 1000.0, type: 'Income'}
```

## Architecture

```
NotificationService
    ↓
TransactionSimulator ←→ UserServices (Balance)
    ↓
MainScreen (Navigation)
    ↓
AddnewScreen (Pre-filled)
```

## Testing Checklist

- [ ] Simulate expense and verify balance decreases
- [ ] Simulate income and verify balance increases
- [ ] Receive notification for each transaction
- [ ] Tap notification and navigate to Add Transaction screen
- [ ] Verify amount and type are pre-filled
- [ ] Complete transaction entry with category selection
- [ ] New transaction appears in transaction list
- [ ] Run demo transactions successfully
- [ ] Handle edge cases (no bank account, negative balance)

## Dependencies

- `flutter_local_notifications: ^18.0.0`
- `shared_preferences: ^2.5.4` (already in project)

## Future Enhancements

- Schedule regular notifications
- Recurring transaction simulation
- Analytics on simulated transactions
- Customizable notification templates
- Transaction history simulation
- Batch simulation with delays

## Troubleshooting

### Notifications not appearing
- Ensure app has notification permissions (Android 13+)
- Check notification settings in device settings
- Verify `NotificationService().initialize()` is called in main()

### Pre-filled data not showing
- Verify `AddnewScreen` constructor has `preFillAmount` and `preFillType`
- Check that `MainScreen` is passing these parameters
- Ensure `initState` is properly initializing the controllers

### Balance not updating
- Verify `storeOnboardingData()` was called during onboarding
- Check SharedPreferences for "totalBalance" key
- Ensure transaction type is exactly "Income" or "Expense"
