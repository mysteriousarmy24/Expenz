import 'package:expenz/Screens/onboardings/page_1.dart';
import 'package:expenz/Screens/onboardings/shared_onboarding_widget.dart';
import 'package:expenz/Screens/user_data_screen.dart';
import 'package:expenz/data/onboard_data.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreens extends StatefulWidget {
  const OnboardScreens({super.key});

  @override
  State<OnboardScreens> createState() => _OnboardScreensState();
}

class _OnboardScreensState extends State<OnboardScreens> {
  bool isPageLoaded = false;
  @override
  Widget build(BuildContext context) {
    final PageController _contraller = PageController();
    final onboardData = OnboardData();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  PageView(
                    controller: _contraller,
                    onPageChanged: (index) {
                      setState(() {
                        isPageLoaded = index == 3;
                        
                      });
                    },

                    children: [
                      //page-01
                      Page1(),
                      //page-02
                      SharedOnboardingWidget(
                        imgUrl: onboardData.onboardList[0].imagePath,
                        title: onboardData.onboardList[0].title,
                        description: onboardData.onboardList[0].description,
                      ),
                      //page-03
                      SharedOnboardingWidget(
                        imgUrl: onboardData.onboardList[1].imagePath,
                        title: onboardData.onboardList[1].title,
                        description: onboardData.onboardList[1].description,
                      ),
                      //page-04
                      SharedOnboardingWidget(
                        imgUrl: onboardData.onboardList[2].imagePath,
                        title: onboardData.onboardList[2].title,
                        description: onboardData.onboardList[2].description,
                      ),
                    ],
                  ),
                  //pageIndicator
                  Container(
                    alignment: Alignment(0, 0.7),
                    child: SmoothPageIndicator(
                      controller: _contraller,
                      count: 4,
                      effect: ExpandingDotsEffect(
                        activeDotColor: kMainColor,
                        dotColor: kLightGrey,
                        dotHeight: 10,
                        dotWidth: 10,
                        spacing: 5,
                      ),
                    ),
                  ),
                  //Button
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 30,
                    child: !isPageLoaded
                        ? GestureDetector(
                            onTap: () {
                              _contraller.animateToPage(
                                _contraller.page!.toInt() + 1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                            child: CustomButton(
                              bgColor: kMainColor,
                              name: isPageLoaded ? "Get Started" : "Next",
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserDataScreen(),
                                ),
                              );
                            },
                            child: CustomButton(
                              bgColor: kMainColor,
                              name: isPageLoaded ? "Get Started" : "Next",
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
