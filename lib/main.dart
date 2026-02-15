import 'package:expenz/Screens/onboard_screens.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/widgets/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserServices.checkUsername(), 
      builder: (context, snapshot) {
        //if snapshot is still waiting 
        if(snapshot.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }else{
          bool hasUserName= snapshot.data??false;
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Expenz",
            theme: ThemeData(
              fontFamily: "Inter"
            ),
            home: Wrapper(showMainScreen: hasUserName)
          );
        }
      },
      );
  }
}