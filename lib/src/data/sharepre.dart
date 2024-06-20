// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
// import 'package:app_api/app/model/cart.dart';
// import 'package:app_api/app/page/auth/login.dart';
import 'package:e_commerce_flutter/src/view/screen/login_screen.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

Future<bool> saveUser(User user) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String strUser = jsonEncode(user);
    prefs.setString('user', strUser);
    print("Luu thanh cong: $strUser");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<User> getUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String strUser = pref.getString('user')!;
  return User.fromJson(jsonDecode(strUser));
}

Future<bool> saveToken(String token) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    print("Luu thanh cong: $token");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> saveID(int id) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id', id);
    print("Luu thanh cong: $id");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> logOut(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', '');
    print("Logout thành công");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> deleteAll(String delete) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('delete', delete);
    print("Luu thanh cong: $delete");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> saveuser_pass(String user, String password) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mail', user);
    prefs.setString('pass', password);
    print("Luu thanh cong: $user");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> savegender(String gender) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('gender', gender);
    print("Luu thanh cong: $gender");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> savebuynow(String price) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('buynow', price);
    print("Luu thanh cong: $price");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> savemail(String mail) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mail', mail);
    print("Luu thanh cong: $mail");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> saveBillID(String billID) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('billID', billID);
    print("Luu thanh cong: $billID");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> savepaypalresult(String result) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('payres', result);
    print("Luu thanh cong: $result");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> savepass(String pass) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('passemp', pass);
    print("Luu thanh cong: $pass");
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}
