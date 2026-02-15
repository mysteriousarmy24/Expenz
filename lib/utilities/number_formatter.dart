/// Formats a number with commas for thousands separator
String formatCurrencyAmount(double amount) {
  // Round to 2 decimal places
  String amountStr = amount.toStringAsFixed(2);
  
  // Split into integer and decimal parts
  List<String> parts = amountStr.split('.');
  String integerPart = parts[0];
  String decimalPart = parts[1];
  
  // Add commas to integer part
  StringBuffer buffer = StringBuffer();
  int count = 0;
  
  // Process from right to left
  for (int i = integerPart.length - 1; i >= 0; i--) {
    if (count > 0 && count % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(integerPart[i]);
    count++;
  }
  
  // Reverse and combine with decimal part
  String result = buffer.toString().split('').reversed.join('') + '.$decimalPart';
  return result;
}
