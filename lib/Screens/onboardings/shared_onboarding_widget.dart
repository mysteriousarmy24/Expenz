import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SharedOnboardingWidget extends StatelessWidget {
  final String imgUrl;
  final String description;
  final String title;
  const SharedOnboardingWidget({
    super.key,
    required this.imgUrl,
    required this.description,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefalutPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Image.asset(imgUrl, fit: BoxFit.cover, width: 250),
          SizedBox(height: 30),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  description,
                  style: TextStyle(color: kGrey, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}
