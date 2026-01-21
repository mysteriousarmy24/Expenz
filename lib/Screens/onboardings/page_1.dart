import 'package:expenz/utilities/colors.dart';
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/logo.png", fit: BoxFit.cover, width: 200),
        SizedBox(height: 20),
        Text(
          "Expenz",
          style: TextStyle(
            color: kMainColor,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 200,),
        
      ],
    );
  }
}
