import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:flutter/material.dart';

class IncomeExpencesWidget extends StatefulWidget {
  final bool isIncome;
  final String value;
  const IncomeExpencesWidget({
    super.key,

    required this.isIncome,
    required this.value,
  });

  @override
  State<IncomeExpencesWidget> createState() => _IncomeExpencesWidgetState();
}

class _IncomeExpencesWidgetState extends State<IncomeExpencesWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: widget.isIncome ? kGreen : kRed,
          ),
          child: Padding(
            padding: const EdgeInsets.all(kDefalutPadding),
            child: Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.15,
                  width: MediaQuery.of(context).size.width*0.15,
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: widget.isIncome
                      ? Image.asset("assets/images/income.png")
                      : Image.asset("assets/images/expense.png"),
                ),
                SizedBox(width: 15,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.isIncome
                        ? Text(
                            "Income",
                            style: TextStyle(color: kWhite, fontSize: 15),
                          )
                        : Text(
                            "Expense",
                            style: TextStyle(color: kWhite, fontSize: 15),
                          ),
                    Text(
                      widget.value,
                      style: TextStyle(
                        color: kWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
