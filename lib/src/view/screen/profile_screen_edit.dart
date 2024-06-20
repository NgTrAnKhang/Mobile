import 'dart:convert';

import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/data/sharepre.dart';
import 'package:e_commerce_flutter/src/model/update.dart';
import 'package:e_commerce_flutter/src/model/user.dart';
import 'package:e_commerce_flutter/src/view/screen/OTP_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileEditScreen> {
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController avatarController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool isObscurePassword = true;
  String name = '';
  String phone = '';
  String mail = '';
  String avatar = '';
  String dob = '';
  String address = '';
  int id = 0;
  String password = '';
  User user = User.userEmpty();
  DateTime now = DateTime.now();
  Future<DateTime> convertStringToDateTime(String input) async {
    try {
      // Perform the conversion
      DateTime dateTime = DateFormat("dd/MM/yyyy").parse(input);

      return dateTime;
    } catch (e) {
      // Handle any errors or invalid input
      print('Invalid input: $input');
      return now;
    }
  }

  Future<void> getDataUser2() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var user = await APIRepository().current(pref.getInt('id')!, 'temp');
      saveUser(user);
      String userString = pref.getString('user') ?? '{}';
      String mailstr = pref.getString('mail')!;
      user = User.fromJson(jsonDecode(userString));
      setState(() {
        name = user.fullname!;
        phone = user.phone!;
        mail = mailstr;
        avatar = user.avatar!;
      });
    } catch (e) {
      // Handle exceptions
      print("Error fetching user data: $e");
    }
  }

  Future<void> getDataUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String userString = pref.getString('user') ?? '{}';
      String mailstr = pref.getString('mail')!;
      user = User.fromJson(jsonDecode(userString));
      setState(() {
        dob = DateFormat('dd/MM/yyyy').format(user.dob!);
        name = user.fullname!;
        phone = user.phone!;
        mail = mailstr;
        avatar = user.avatar!;
        address = user.address!;
        id = pref.getInt('id')!;
        password = pref.getString('passemp')!;

        dobController.text = DateFormat('dd/MM/yyyy').format(user.dob!);
        fullnameController.text = user.fullname!;
        phoneController.text = user.phone!;
        avatarController.text = user.avatar!;
        addressController.text = user.address!;
        passwordController.text = pref.getString('passemp')!;
      });
    } catch (e) {
      // Handle exceptions
      print("Error fetching user data: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hồ sơ người dùng',
          style: TextStyle(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.blue,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.blue,
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(width: 4, color: Colors.white),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: NetworkImage(avatar))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Colors.white,
                            ),
                            color: Colors.blue,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
              const SizedBox(height: 30),
              buildTextField("Full Name", name, false, fullnameController),
              buildTextField("Password", '', true, passwordController),
              buildTextField("Số điện thoại", phone, false, phoneController),
              buildTextField("Địa chỉ", address, false, addressController),
              buildTextField("DD/MM/YYYY", dob, false, dobController),
              buildTextField("Avatar", '', false, avatarController),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text('Huỷ',
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime dateTime =
                        await convertStringToDateTime(dobController.text);
                    String formattedDateTime =
                        DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime);
                    UpdateModel usersave = UpdateModel(
                        customerId: id,
                        password: password,
                        avatar: avatarController.text,
                        phone: phoneController.text,
                        address: addressController.text,
                        dob: formattedDateTime,
                        fullName: fullnameController.text);
                    try {
                      await APIRepository().updateUser(usersave);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OTPUpdate()),
                      );
                      getDataUser2();
                      Navigator.pop(context);
                    } catch (e) {}
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text('Lưu',
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white)),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        isObscurePassword = !isObscurePassword;
                      });
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
