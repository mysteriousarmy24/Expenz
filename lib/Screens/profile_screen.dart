import 'package:expenz/Screens/onboard_screens.dart';
import 'package:expenz/services/expense_service.dart';
import 'package:expenz/services/income_services.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/widgets/profile_card.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  String username = "";
  String email = "";
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                  GestureDetector(
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
                  ),
                  GestureDetector(
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
                  ),
                  GestureDetector(
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
                  ),
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
    );
  }
}
