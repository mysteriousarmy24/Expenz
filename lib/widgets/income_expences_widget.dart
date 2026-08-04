import 'package:expenz/utilities/colors.dart';
import 'package:flutter/material.dart';

class IncomeExpencesWidget extends StatelessWidget {
  final bool isIncome;
  final String value;
  const IncomeExpencesWidget({
    super.key,

    required this.isIncome,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 175;
        return Container(
          constraints: const BoxConstraints(minHeight: 100),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: isIncome ? kGreen : kRed,
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 12 : 16),
            child: Row(
              children: [
                Container(
                  height: compact ? 40 : 48,
                  width: compact ? 40 : 48,
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(isIncome ? 'assets/images/income.png' : 'assets/images/expense.png'),
                  ),
                ),
                SizedBox(width: compact ? 8 : 12),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(isIncome ? 'Income' : 'Expense', style: const TextStyle(color: kWhite, fontSize: 15)),
                    Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}
