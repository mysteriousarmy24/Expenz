import 'package:expenz/Screens/onboardings/page_1.dart';
import 'package:expenz/Screens/onboardings/shared_onboarding_widget.dart';
import 'package:expenz/Screens/onboardings/bank_selection_screen.dart';
import 'package:expenz/Screens/onboardings/starting_balance_screen.dart';
import 'package:expenz/Screens/user_data_screen.dart';
import 'package:expenz/data/onboard_data.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/services/monthly_archive_service.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/widgets/custom_button.dart';
import 'package:expenz/widgets/previous_months_expense_dialog.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardScreens extends StatefulWidget {
  const OnboardScreens({super.key});

  @override
  State<OnboardScreens> createState() => _OnboardScreensState();
}

class _OnboardScreensState extends State<OnboardScreens> {
  bool isPageLoaded = false;
  String? selectedBank;
  double? startingBalance;
  late PageController _contraller;

  @override
  void initState() {
    super.initState();
    _contraller = PageController();
  }

  @override
  void dispose() {
    _contraller.dispose();
    super.dispose();
  }

  void _navigateToUserData() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserDataScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        isPageLoaded = index == 5;
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
                      //page-05: Bank Selection
                      BankSelectionScreen(
                        onBankSelected: (bank) {
                          setState(() {
                            selectedBank = bank;
                          });
                        },
                      ),
                      //page-06: Starting Balance
                      if (selectedBank != null)
                        StartingBalanceScreen(
                          primaryBankAccount: selectedBank!,
                          onBalanceSubmitted: (balance) async {
                            setState(() {
                              startingBalance = balance;
                            });
                            
                            // Save onboarding data
                            try {
                              await UserServices.storeOnboardingData(
                                primaryBankAccount: selectedBank!,
                                startingBalance: balance,
                                onboardingDate: DateTime.now(),
                              );
                              
                              if (mounted) {
                                // Show dialog to ask about previous months
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => PreviousMonthsExpenseDialog(
                                    onSave: (monthlyExpenses) async {
                                      try {
                                        await UserServices.saveMonthlyExpenses(
                                          monthlyExpenses,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Previous months data saved!',
                                            ),
                                          ),
                                        );
                                        
                                        _navigateToUserData();
                                      } catch (err) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error saving monthly data: ${err.toString()}',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    onSkip: () {
                                      _navigateToUserData();
                                    },
                                  ),
                                );
                              }
                            } catch (err) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error saving data: ${err.toString()}",
                                  ),
                                ),
                              );
                            }
                          },
                        )
                      else
                        Container(),
                    ],
                  ),
                  //pageIndicator
                  Container(
                    alignment: Alignment(0, 0.7),
                    child: SmoothPageIndicator(
                      controller: _contraller,
                      count: 6,
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
                              // Check if bank is selected on bank selection page
                              if (_contraller.page?.toInt() == 4 && selectedBank == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Please select a bank account"),
                                  ),
                                );
                                return;
                              }
                              
                              _contraller.animateToPage(
                                _contraller.page!.toInt() + 1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeInOutCubic,
                              );
                            },
                            child: CustomButton(
                              bgColor: kMainColor,
                              name: "Next",
                            ),
                          )
                        : Container(),
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

