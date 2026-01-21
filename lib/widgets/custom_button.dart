import 'package:expenz/utilities/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color bgColor;
  final String name;
  const CustomButton({super.key, required this.bgColor, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        height: MediaQuery.of(context).size.width*0.12,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: bgColor
        ),
        child: Center(
          child: Text(name,style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kWhite
          ),),
        ),
      ),
    );
  }
}
