import 'package:expenz/utilities/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color bgColor;
  final String name;
  const CustomButton({super.key, required this.bgColor, required this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48, maxHeight: 56),
        child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: bgColor
        ),
          child: Center(
          child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: kWhite
          ),),
        )),
      ),
    );
  }
}
