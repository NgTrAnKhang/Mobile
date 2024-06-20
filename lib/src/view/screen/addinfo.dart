import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/model/register.dart';
import 'package:e_commerce_flutter/src/view/screen/OTP_Register.dart';
import 'package:e_commerce_flutter/src/view/screen/genderhandler.dart';
import 'package:e_commerce_flutter/src/view/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InforPage extends StatefulWidget {
  const InforPage({super.key});

  @override
  State<InforPage> createState() => _InforPageState();
}

class _InforPageState extends State<InforPage> {
  Register user = Register.registerEmpty();
  String? username;
  String? password;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  DateTime now = DateTime.now();
  // Register register = Register.registerEmpty();
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

  signup() async {
    DateTime dateTime = await convertStringToDateTime(dobController.text);
    String formattedDateTime =
        DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('mail')!;
    String pass = prefs.getString('pass')!;
    String gender = prefs.getString('gender')!;
    try {
      String res = await APIRepository().register(Register(
          fullname: fullnameController.text,
          address: addressController.text,
          phone: phoneController.text,
          username: username,
          password: pass,
          dob: formattedDateTime,
          gender: gender,
          avatar: 'avatar'));
      return res;
    } catch (e) {
      return 'fail';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: (MediaQuery.of(context).size.width) / 3,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Text(
                        'Hoàn thành thông tin tài khoản!',
                        style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.width) / 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 30, left: 30, right: 30),
                      child: Column(
                        children: <Widget>[
                          FadeInUp(
                            duration: const Duration(milliseconds: 1800),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          68, 143, 255, 1)),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Color.fromRGBO(68, 143, 255, .3),
                                        blurRadius: 20.0,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(68, 143, 255, 1),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: fullnameController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Họ và tên",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(68, 143, 255, 1),
                                        ),
                                      ),
                                    ),
                                    child: GenderSelectionPage(),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(68, 143, 255, 1),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: dobController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "dd/mm/YYYY",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color:
                                              Color.fromRGBO(68, 143, 255, 1),
                                        ),
                                      ),
                                    ),
                                    child: TextField(
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Số điện thoại",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextField(
                                      controller: addressController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Địa chỉ",
                                          hintStyle: TextStyle(
                                              color: Colors.grey[700])),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.width) / 10,
                          ),
                          FadeInUp(
                              duration: const Duration(milliseconds: 1900),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  // Customize button's background color
                                  // Customize button's elevation
                                  backgroundColor:
                                      const Color.fromRGBO(68, 143, 255, 1),
                                  elevation: 4,
                                  // Customize button's shape
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  final bool? result =
                                      await Navigator.push<bool>(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OTPRegister()),
                                  );
                                  if (result == true) {
                                    signup();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage()));
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.26,
                                      right: MediaQuery.of(context).size.width *
                                          0.26),
                                  child: const Text(
                                    'Hoàn thành',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              )),
                          FadeInUp(
                            duration: const Duration(milliseconds: 1900),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  color: const Color.fromRGBO(68, 143, 255, 1),
                                  gradient: const LinearGradient(colors: [
                                    Color.fromRGBO(255, 255, 255, 1),
                                    Color.fromRGBO(255, 255, 255, 1),
                                  ])),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: AppBar(
                  leading: IconButton(
                    color: Colors.grey[600],
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    'Đăng ký',
                    style: TextStyle(color: Colors.grey[600], fontSize: 30),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
