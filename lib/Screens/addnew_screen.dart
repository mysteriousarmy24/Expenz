import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:flutter/material.dart';

class AddnewScreen extends StatefulWidget {
  const AddnewScreen({super.key});

  @override
  State<AddnewScreen> createState() => _AddnewScreenState();
}

class _AddnewScreenState extends State<AddnewScreen> {
  int _selectedMethod=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedMethod==0?kRed:kGreen,
      body: SafeArea(child: 
      Padding(
        padding: const EdgeInsets.all(kDefalutPadding),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.07,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(100)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMethod=0;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: _selectedMethod==0?kRed:kWhite,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 15),
                          child: Text("Expense",style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedMethod==0?kWhite:Colors.black,
                          ),),
                        )
                        ),
                    ),
                    
                     GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedMethod=1;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: _selectedMethod==1?kGreen:kWhite,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 15),
                            child: Text("Income",style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _selectedMethod==1?kWhite:Colors.black,
                            ),),
                          )
                          ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
