import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/number_formatter.dart';
import 'package:flutter/material.dart';

class CategoryChartCard extends StatefulWidget {
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
  State<CategoryChartCard> createState() => _CategoryChartCardState();
}

class _CategoryChartCardState extends State<CategoryChartCard> {
  @override
  Widget build(BuildContext context) {
    double progressWidth = widget.total!=0?MediaQuery.of(context).size.width*(widget.amount/widget.total):0;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      height: MediaQuery.of(context).size.height*0.11,
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(20),
        color: kWhite ,
        
      ),child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: widget.progressColor.withOpacity(0.3)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color:widget.progressColor,
                            borderRadius: BorderRadius.circular(100)
                          ),
                        ),
                        SizedBox(width: 5,),
                        Text(widget.title,style: TextStyle(
                          fontSize: 12,fontWeight: FontWeight.w600
                        ),),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Text("${(widget.amount/widget.total *100).toStringAsFixed(2)}%",style: TextStyle(
                          fontSize: 12,fontWeight: FontWeight.w600,color: kGrey.withOpacity(0.8)
                        ),),
                Spacer(),
                Text("LKR ${formatCurrencyAmount(widget.amount)}",style: TextStyle(
                  color:widget.isExpense? kRed:kGreen,
                  fontSize: 16
                ),)
        
              ],
            ),
            SizedBox(height: 10,),
            //progress bar
            Container(
              height: 10,
              width:progressWidth ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: widget.progressColor
              ),
            )
          ],
        ),
      ),
    );
  }
}
