import 'package:expenz/Screens/onboard_screens.dart';
import 'package:expenz/models/expenses_models.dart';
import 'package:expenz/services/expense_service.dart';
import 'package:expenz/services/income_services.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/widgets/profile_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final List<Expense>? expensesList;
  final double? totalBalance;

  const ProfileScreen({
    super.key,
    this.expensesList,
    this.totalBalance,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  String email = "";
  double totalBalance = 0.0;
  double totalExpenses = 0.0;

  double calculateTotalExpenses() {
    if (widget.expensesList == null) return 0.0;
    double total = 0.0;
    for (Expense expense in widget.expensesList!) {
      total += expense.amount;
    }
    return total;
  }

  void _loggingOut(BuildContext contex) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          decoration: BoxDecoration(
            color: kGrey.withOpacity(0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Logout?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kBlack,
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xFFEEE5FF))),
                    onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("No",style: TextStyle(
                      color: kMainColor,fontSize: 20
                    ),)),
                    SizedBox(width: 10,),
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(kMainColor)),
                    onPressed: ()async{
                      await UserServices().removeDetails();
                      await ExpenseService().deleAllExpenses(contex);
                      await IncomeServices().deleAllIncomes(contex);
                      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>OnboardScreens(),),(route)=>false);
                    }, child: Text("Yes",style: TextStyle(
                      color: kWhite,fontSize: 20
                    ),),
                    
                    )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    UserServices.getUserData().then((value) {
      if ((value["username"] != null) && (value["email"] != null)) {
        setState(() {
          username = value["username"]!;
          email = value['email']!;
        });
      }
    });
    
    // Load totalBalance from parameters or SharedPreferences
    if (widget.totalBalance != null) {
      setState(() {
        totalBalance = widget.totalBalance!;
      });
    } else {
      UserServices.getTotalBalance().then((balance) {
        setState(() {
          totalBalance = balance;
        });
      });
    }

    // Calculate total expenses
    setState(() {
      totalExpenses = calculateTotalExpenses();
    });
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: kWhite,
                        border: Border.all(color: kMainColor.withOpacity(0.2), width: 5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(100),
                        child: Image.asset(
                          "assets/images/person.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            email,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: kGrey.withOpacity(0.5),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            username,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: kBlack,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: kGrey.withOpacity(0.5)),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.edit),
                          color: kBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    // Balance Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [kMainColor, kMainColor.withOpacity(0.7)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: kMainColor.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Balance",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.account_balance_wallet,
                                color: Colors.white,
                                size: 28,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "LKR ${totalBalance.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            totalBalance < 0 ? "Negative Balance" : "Available",
                            style: TextStyle(
                              color: totalBalance < 0 ? Colors.red.shade200 : Colors.greenAccent,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Pie Chart - Expense Distribution
                    if (totalBalance > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Expense Distribution",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kBlack,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 180,
                                  child: PieChart(
                                    PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          value: totalExpenses,
                                          radius: 50,
                                          color: const Color(0xFFFF6B6B),
                                          title:
                                              "${((totalExpenses / totalBalance) * 100).toStringAsFixed(1)}%",
                                          titleStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          value: totalBalance - totalExpenses,
                                          radius: 50,
                                          color: const Color(0xFF4ECDC4),
                                          title:
                                              "${(((totalBalance - totalExpenses) / totalBalance) * 100).toStringAsFixed(1)}%",
                                          titleStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                      centerSpaceRadius: 0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF6B6B),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          "Expenses",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: kBlack,
                                          ),
                                        ),
                                        Text(
                                          "LKR ${totalExpenses.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFF6B6B),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF4ECDC4),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        const Text(
                                          "Remaining",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: kBlack,
                                          ),
                                        ),
                                        Text(
                                          "LKR ${(totalBalance - totalExpenses).toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4ECDC4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (totalBalance <= 0)
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red.shade400),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Negative Balance",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "LKR ${totalBalance.toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 30),
                    /*GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("This feature will come in next update..."))
                        );
                      },
                      child: ProfileCard(
                        icon: Icons.wallet,
                        title: "My Wallet",
                        color: kMainColor,
                      ),
                    ),*/
                    /*GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("This feature will come in next update..."))
                        );
                      },
                      child: ProfileCard(
                        icon: Icons.download,
                        title: "Export Data",
                        color: kGreen,
                      ),
                    ),*/
                    /*GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("This feature will come in next update..."))
                        );
                      },
                      child: ProfileCard(
                        icon: Icons.settings,
                        title: "Settings",
                        color: kOrange,
                      ),
                    ),*/
                    GestureDetector(
                      onTap: () {
                        _loggingOut(context);
                      },
                      child: ProfileCard(
                        icon: Icons.logout,
                        title: "Logout",
                        color: kRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
