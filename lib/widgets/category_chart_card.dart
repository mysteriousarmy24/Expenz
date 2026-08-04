import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/number_formatter.dart';
import 'package:flutter/material.dart';

class CategoryChartCard extends StatelessWidget {
  final String title;
  final Color progressColor;
  final double amount;
  final double total;
  final bool isExpense;
  const CategoryChartCard({
    super.key,
    required this.title,
    required this.progressColor,
    required this.amount,
    required this.total,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? (amount / total).clamp(0.0, 1.0).toDouble() : 0.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(20),
        color: kWhite ,
        
      ),child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: progressColor, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                const SizedBox(width: 8),
                Flexible(child: Text('LKR ${formatCurrencyAmount(amount)}', maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end, style: TextStyle(color: isExpense ? kRed : kGreen, fontSize: 15, fontWeight: FontWeight.w600)))
        
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: LinearProgressIndicator(value: progress, minHeight: 10, color: progressColor, backgroundColor: progressColor.withOpacity(.18)),
            ),
            const SizedBox(height: 6),
            Text('${(progress * 100).toStringAsFixed(2)}%', style: TextStyle(fontSize: 12, color: kGrey.withOpacity(.8))),
          ],
        ),
      ),
    );
  }
}
