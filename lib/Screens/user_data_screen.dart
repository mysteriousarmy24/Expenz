import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:expenz/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  //key
  final _formKey = GlobalKey<FormState>();
  //contrallers
  final TextEditingController _userNameControllar = TextEditingController();
  final TextEditingController _emailControllar = TextEditingController();
  final TextEditingController _passwordControllar = TextEditingController();
  final TextEditingController _comfirmPasswordControllar =
      TextEditingController();
      @override
  void dispose() {
    // TODO: implement dispose
    _userNameControllar.dispose();
    _emailControllar.dispose();
    _passwordControllar.dispose();
    _comfirmPasswordControllar.dispose();
    super.dispose();
  }
      
  
  bool _rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your\nPersonal Details",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                //forms
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //input userName
                      TextFormField(
                
                        
                        controller: _userNameControllar,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter your Name";
                          }
                          
                        },
                        decoration: InputDecoration(
                        
                          hintText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.all(kDefalutPadding),
                        ),
                      ),
                      SizedBox(height: 15),
                      //input email
                      TextFormField(
                        controller: _emailControllar,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter your Email";
                          }
                          
                        },

                        decoration: InputDecoration(
                          hintText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.all(kDefalutPadding),
                        ),
                      ),
                      SizedBox(height: 15),
                      //input password
                      TextFormField(
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter your Password";
                          }
                          
                        },
                        controller: _passwordControllar,

                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.all(kDefalutPadding),
                        ),
                      ),
                      SizedBox(height: 15),
                      //input Comformpassword
                      TextFormField(
                        controller: _comfirmPasswordControllar,
                        obscureText: true,
                        validator: (value) {
                          if(value!.isEmpty){
                            return "Please enter same Confirm Password";
                          }
                          
                        },
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.all(kDefalutPadding),
                        ),
                      ),
                      SizedBox(height: 30),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Remember me for next time",
                            style: TextStyle(color: kGrey, fontSize: 15),
                          ),
                          SizedBox(width: 30),
                          //check box
                          Expanded(
                            child: CheckboxListTile(
                              activeColor: kMainColor,
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () {
                      if(_formKey.currentState!.validate()){
                        String userName=_userNameControllar.text;
                        String email=_emailControllar.text;
                        String password=_passwordControllar.text;
                        String comfirmPassword=_comfirmPasswordControllar.text;
                      }
                    },
                    child: CustomButton(bgColor: kMainColor, name: "Next"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
