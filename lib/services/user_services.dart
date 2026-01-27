import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  // Method to store shared preferences
  static Future<void> storeUserData({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    try {
      // Check if password and confirmPassword match
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Password & Confirm Password do not match..."),
          ),
        );
        return;
        // Exit early if mismatch
      }

      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString("username", userName);
      await pref.setString("email", email);
      await pref.setString(
        "password",
        password,
      ); // Optional: store password if needed

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Data stored successfully...")));
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error storing data: ${err.toString()}")),
      );
    }
  }

  //method to check that details are saved
  static Future<bool> checkUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userName = pref.getString('username');
    return userName != null;
  }

  //get the username & password
  static Future <Map <String,String>> getUserData() async{
    //creating an  instance
    SharedPreferences prefs =await SharedPreferences.getInstance();
    String? userName = prefs.getString("username");
    String? email = prefs.getString("email");
    return {"username":userName!,"email":email!};
  }
}
