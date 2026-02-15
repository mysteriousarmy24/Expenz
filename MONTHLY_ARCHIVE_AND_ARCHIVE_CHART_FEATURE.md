# Monthly Archive & Annual Chart + UI Sync Feature

## Overview
This feature implements a complete monthly expense archiving system with annual chart visualization and UI synchronization across the app. It automatically tracks monthly expenses, provides manual input for previous months during onboarding, and ensures the UI updates in real-time.

## Features

### 1. Monthly Archive System
- **Automatic Archive**: Runs every 30 days from onboarding date
- **Monthly Aggregation**: Calculates sum of all expenses for the past month
- **12-Month Storage**: Maintains year-long expense data (one value per month)
- **Transaction Clearing**: Optional clearing of individual transactions after archiving
- **Validation**: Prevents negative expenses and validates date ranges

### 2. Annual Chart Visualization
- **LineChart Integration**: Uses `fl_chart` for 12-month trend visualization
- **Dynamic Data**: Chart updates automatically with actual monthly data
- **Auto-Scaling**: Scales data to fit chart display (divides by 10,000)
- **Fallback UI**: Shows default pattern if no data available

### 3. Previous Months Input Dialog
- **Onboarding Integration**: Shows after starting balance entry
- **12-Month Input**: Manual entry fields for all months
- **Validation**: Ensures non-negative values
- **Save/Skip Options**: Allows users to populate or skip historical data

### 4. UI Synchronization
- **Profile Section**: Displays current totalBalance with visual card
- **Home Screen**: Shows updated annual chart automatically
- **Real-Time Updates**: Balance updates when transactions occur
- **Archive Notifications**: Alerts user when monthly archive completes

## Architecture

```
┌─────────────────────────────────────────┐
│     Onboarding Flow                     │
├─────────────────────────────────────────┤
│ 1. Bank Selection                       │
│ 2. Starting Balance Entry               │
│ 3. Previous Months Dialog (Optional)    │
│ 4. User Data Entry                      │
└─────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────┐
│     UserServices Storage                │
├─────────────────────────────────────────┤
│ • totalBalance (double)                 │
│ • monthlyExpenses (List<double>)        │
│ • lastArchiveDate (DateTime)            │
│ • onboardingDate (DateTime)             │
└─────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────┐
│     MonthlyArchiveService               │
├─────────────────────────────────────────┤
│ • archiveMonthlyExpenses()              │
│ • getMonthlyExpenses()                  │
│ • setMonthlyExpenses()                  │
│ • isMonthlyArchiveDue()                 │
│ • getNextArchiveDate()                  │
└─────────────────────────────────────────┘
         ↓
┌─────────────────────────────────────────┐
│     UI Components                       │
├─────────────────────────────────────────┤
│ • HomeScreen (LineChart + Archive)      │
│ • ProfileScreen (Balance Display)       │
│ • LineChartSample (Dynamic Data)        │
└─────────────────────────────────────────┘
```

## Key Components

### 1. **MonthlyArchiveService** (`lib/services/monthly_archive_service.dart`)

Core service managing all month-related operations:

```dart
// Check if archive is due
bool isDue = await MonthlyArchiveService().isMonthlyArchiveDue();

// Archive current month
await MonthlyArchiveService().archiveMonthlyExpenses();

// Get monthly data
List<double> expenses = await MonthlyArchiveService().getMonthlyExpenses();

// Set monthly data manually
await MonthlyArchiveService().setMonthlyExpenses([5000, 6000, ...]);

// Get next archive date
DateTime? nextDate = await MonthlyArchiveService().getNextArchiveDate();
```

**Methods:**

| Method | Purpose | Returns |
|--------|---------|---------|
| `archiveMonthlyExpenses()` | Calculates and archives monthly total | void |
| `getMonthlyExpenses()` | Retrieves all 12 monthly values | List<double> |
| `setMonthlyExpenses(List<double>)` | Manually set monthly data | void |
| `isMonthlyArchiveDue()` | Check if 30 days passed | bool |
| `getNextArchiveDate()` | Get scheduled archive date | DateTime? |
| `markArchiveComplete()` | Update last archive timestamp | void |
| `getMonthName(int)` | Static helper for month names | String |
| `getMonthAbbr(int)` | Static helper for abbreviations | String |

### 2. **UserServices Enhancements** (`lib/services/user_services.dart`)

New methods for monthly data management:

```dart
// Save 12-month expense data
await UserServices.saveMonthlyExpenses([500, 600, 700, ...]);

// Retrieve monthly expenses
List<double>? expenses = await UserServices.getMonthlyExpenses();

// Set last archive date
await UserServices.setLastArchiveDate(DateTime.now());

// Get last archive date
DateTime? lastArchive = await UserServices.getLastArchiveDate();
```

### 3. **LineChartSample** (`lib/widgets/line_chart_sample.dart`)

Updated to accept and display monthly expense data:

```dart
// Pass monthly data to chart
LineChartSample(
  monthlyExpenses: [5000, 6000, 7000, ...],
)

// Features:
// • Dynamic scaling (divides by 10,000 for visualization)
// • Automatic clipping to chart bounds (0-6)
// • Fallback to default pattern if no data
// • Month labels for Jan, Jun, Sep
```

**Data Scaling:**
- Raw value: ₹50,000 → Chart value: 5.0
- Raw value: ₹10,000 → Chart value: 1.0
- Raw value: ₹0 → Chart value: 0.0

### 4. **HomeScreen Integration** (`lib/Screens/home_screen.dart`)

Auto-archive checking and monthly data display:

```dart
@override
void initState() {
  super.initState();
  _loadUserData();           // Load monthly expenses
  _checkAndArchiveMonthly(); // Check if archive is due
}

// Features:
// • Loads monthly expenses on screen init
// • Checks if archive is due
// • Performs auto-archive if necessary
// • Reloads data and shows notification
// • Passes data to LineChartSample
```

### 5. **ProfileScreen Updates** (`lib/Screens/profile_screen.dart`)

Displays current total balance:

```dart
// Balance card features:
// • Shows formatted balance with rupee symbol
// • Gradient background
// • Icon and visual hierarchy
// • Updates when app reloads or balance changes
// • Positioned prominently after user info
```

**Balance Display Format:**
```
┌──────────────────────────────┐
│   Total Balance              │
│   💰 ₹50,000.00             │
└──────────────────────────────┘
```

### 6. **Previous Months Dialog** (`lib/widgets/previous_months_expense_dialog.dart`)

Input form for historical expense data:

```dart
PreviousMonthsExpenseDialog(
  onSave: (monthlyExpenses) {
    // Save 12 monthly values
  },
  onSkip: () {
    // Continue without historical data
  },
)

// Features:
// • 12 input fields (one per month)
// • Currency formatting with ₹ symbol
// • Validation for negative values
// • Save/Skip buttons
// • Informational note
```

### 7. **Onboarding Integration** (`lib/Screens/onboard_screens.dart`)

Flow after starting balance entry:

```
Starting Balance Input
        ↓
Save Onboarding Data
        ↓
Show Previous Months Dialog
        ↓
[User Input or Skip]
        ↓
Navigate to User Data Screen
```

## Data Storage

All data stored in SharedPreferences with the following keys:

| Key | Type | Purpose |
|-----|------|---------|
| `totalBalance` | double | Current account balance |
| `startingBalance` | double | Initial balance from onboarding |
| `onboardingDate` | String (ISO8601) | User's onboarding date |
| `monthlyExpenses` | List<String> | 12 monthly totals |
| `lastArchiveDate` | String (ISO8601) | Last archive timestamp |

**Example monthlyExpenses storage:**
```
["5000.0", "6000.0", "7000.0", "5500.0", "6200.0", ...]
```

## Monthly Archive Logic

### Archive Trigger
- First archive: 30 days after onboarding
- Subsequent archives: Every 30 days from last archive

### Archive Process
1. **Date Validation**: Verify onboarding date exists
2. **Expense Collection**: Get all expenses from past 30 days
3. **Sum Calculation**: Calculate total for the month
4. **Storage Update**: Add to appropriate month slot (0-11 for Jan-Dec)
5. **Timestamp Update**: Record archive completion time
6. **Notification**: Alert user of successful archive

### Month Index Mapping
```dart
0  = January      7  = August
1  = February     8  = September
2  = March        9  = October
3  = April        10 = November
4  = May          11 = December
5  = June
6  = July
```

## Chart Visualization

### Data Scaling Formula
```
Chart Value = (Raw Expense / 10,000).clamp(0, 6)
```

### Example Visualization
```
Raw Expenses: [50000, 60000, 70000, 55000, 62000, ...]
Chart Values: [5.0, 6.0, 7.0≈6.0, 5.5, 6.2≈6.0, ...]
```

### Axis Ranges
- X-axis: 0 to 11 (12 months)
- Y-axis: 0 to 6 (represents 0 to 60,000+ expenses)

### Scaling Labels
- Y = 1 → ₹10,000
- Y = 3 → ₹30,000
- Y = 5 → ₹50,000
- Y = 6 → ₹60,000+ (max)

## UI Update Flow

```
Transaction Added/Removed
        ↓
HomeScreen notified
        ↓
Check monthly archive due?
        ↓
        ├─ YES: Archive & Reload Data
        └─ NO: Continue
        ↓
Load Monthly Expenses
        ↓
Pass to LineChartSample
        ↓
Chart Renders with New Data
        ↓
User sees updated visualization
```

## Usage Examples

### Manual Monthly Archive
```dart
MonthlyArchiveService service = MonthlyArchiveService();

// Check if due
bool isDue = await service.isMonthlyArchiveDue();
if (isDue) {
  await service.archiveMonthlyExpenses();
  await service.markArchiveComplete();
}
```

### Set Historical Data During Onboarding
```dart
List<double> previousMonths = [
  5000,   // January
  6000,   // February
  7000,   // March
  // ... etc
];

await UserServices.saveMonthlyExpenses(previousMonths);
```

### Get Annual Statistics
```dart
List<double> expenses = await MonthlyArchiveService().getMonthlyExpenses();

double total = expenses.fold(0.0, (sum, value) => sum + value);
double average = total / 12;
double max = expenses.reduce((a, b) => a > b ? a : b);
```

### Get Monthly Expense for Specific Month
```dart
// Get March (index 2)
double marchExpense = await MonthlyArchiveService().getMonthExpense(2);
```

## User Journey

### First-Time User
1. Complete onboarding with bank selection
2. Enter starting balance
3. See previous months dialog
   - Option A: Enter historical expenses
   - Option B: Skip (starts fresh)
4. Complete user data entry
5. See dashboard with populated or empty chart

### Returning User After 30 Days
1. Open app
2. HomeScreen checks if archive is due
3. If due:
   - Automatically archives previous month
   - Calculates expense total
   - Updates monthly data
   - Shows notification
   - Chart updates automatically

## Validation & Error Handling

### Input Validation
- Monthly expenses must be non-negative
- Starting balance must be valid number
- Requires exactly 12 values for monthly data

### Error Cases Handled
- Missing onboarding date
- Invalid expense data
- Archive already performed
- Negative balance prevention (in future)

## Future Enhancements

- **Archive Notifications**: Scheduled daily reminder
- **Category Breakdown**: Monthly expenses by category
- **Year Selection**: View multiple years
- **Forecast**: Predict future expenses
- **Alerts**: Budget threshold warnings
- **Export**: Download annual report
- **Trends**: Growth/decline analysis

## Testing Checklist

- [ ] Onboarding shows previous months dialog
- [ ] Dialog saves/skips correctly
- [ ] Balance displays in profile screen
- [ ] Chart updates with monthly data
- [ ] Archive checks trigger at 30 days
- [ ] Archive correctly sums expenses
- [ ] HomeScreen reloads data after archive
- [ ] Notification appears on archive
- [ ] Chart scales properly
- [ ] Month labels display correctly
- [ ] Previous months manual entry works
- [ ] Balance persists across sessions
- [ ] All 12 months display in chart

## Performance Considerations

- **SharedPreferences Reads**: Cached in initState
- **Expense Filtering**: Uses date range for efficiency
- **Chart Rendering**: Optimized with aspect ratio
- **Archive Checking**: Only on HomeScreen init
- **Memory**: Stores only 12 values + metadata

## Troubleshooting

### Chart Not Showing Data
- Verify `monthlyExpenses` list has 12 values
- Check values are double type
- Ensure chart widget receives non-null data

### Archive Not Running
- Verify onboarding date is saved
- Check if 30 days have passed
- Ensure HomeScreen init is called

### Balance Not Updating
- Verify transaction saves totalBalance
- Check SharedPreferences key spelling
- Reload ProfileScreen after changes

### Dialog Not Appearing
- Verify onboard_screens imports PreviousMonthsExpenseDialog
- Check mounted state before showing dialog
- Verify UserServices.saveMonthlyExpenses works

## Architecture Decisions

1. **30-Day Cycle**: Based on onboarding date for personalization
2. **12-Value Storage**: Represents calendar year consistently
3. **Monthly Totals**: Prevents transaction list bloat
4. **Auto-Archive**: Reduces manual data management
5. **Optional History**: Users can start fresh or import data
6. **LocalNotification**: Informs users of important events

## Dependencies

```yaml
shared_preferences: ^2.5.4  # Data persistence
fl_chart: ^1.1.1            # Chart visualization
flutter_local_notifications: ^18.0.0  # Notifications (existing)
```
