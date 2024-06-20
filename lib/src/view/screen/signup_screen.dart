import 'package:e_commerce_flutter/src/data/sharepre.dart';
import 'package:e_commerce_flutter/src/view/screen/addinfo.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmpasswordController = TextEditingController();
    final screenWidth = MediaQuery.of(context).size.width;
    const maxWidthPercentage = 0.6;
    final maxWidth = screenWidth * maxWidthPercentage;

    return Expanded(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: (MediaQuery.of(context).size.width) / 2,
                    ),
                    FadeInUp(
                      duration: const Duration(milliseconds: 1800),
                      child: Text(
                        'Nhập thông tin tài khoản',
                        style: TextStyle(fontSize: 24, color: Colors.grey[700]),
                      ),
                    ),
                    SizedBox(
                      height: (MediaQuery.of(context).size.width) / 5.9,
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
                                          color:
                                              Color.fromRGBO(68, 143, 255, .3),
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
                                        controller: emailController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Email",
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
                                        obscureText: true,
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Mật khẩu",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[700])),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextField(
                                        obscureText: true,
                                        controller: confirmpasswordController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Nhập lại mật khẩu",
                                            hintStyle: TextStyle(
                                                color: Colors.grey[700])),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: (MediaQuery.of(context).size.width) / 7,
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
                              onPressed: () {
                                bool passwordsMatch =
                                    (passwordController.text ==
                                        confirmpasswordController.text);
                                if (passwordsMatch) {
                                  print("Passwords match");
                                  saveuser_pass(emailController.text,
                                      passwordController.text);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InforPage()));
                                } else {
                                  print("Passwords do not match");
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.28,
                                    right: MediaQuery.of(context).size.width *
                                        0.28),
                                child: const Text(
                                  'Đăng ký',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.width) / 15,
                          ),
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
                              child: Center(
                                  child: TextButton(
                                      onPressed: () {},
                                      style: TextButton.styleFrom(),
                                      child: const Text(
                                        'Đã có tài khoản? Đăng nhập',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ))),
                            ),
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.width) / 10,
                          ),
                          FadeInUp(
                            duration: const Duration(milliseconds: 2000),
                            child: SizedBox(
                              width: maxWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // Handle onTap event
                                    },
                                    child: Container(
                                      width:
                                          40, // Adjust width and height as needed
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 255,
                                              255, 255), // Border color
                                          width: 4, // Border width
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 209, 209, 209)
                                                .withOpacity(
                                                    0.6), // Shadow color
                                            // Blur radius
                                            offset: const Offset(
                                                0, 3), // Offset of the shadow
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/gglogo.png',
                                          width:
                                              30, // Adjust width and height as needed
                                          height: 30,
                                          fit: BoxFit
                                              .cover, // Ensure the image fills the circular container
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Handle onTap event
                                    },
                                    child: Container(
                                      width:
                                          40, // Adjust width and height as needed
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 255,
                                              255, 255), // Border color
                                          width: 4, // Border width
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 209, 209, 209)
                                                .withOpacity(
                                                    0.6), // Shadow color
                                            // Blur radius
                                            offset: const Offset(
                                                0, 3), // Offset of the shadow
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/fblogo.png',
                                          width:
                                              30, // Adjust width and height as needed
                                          height: 30,
                                          fit: BoxFit
                                              .cover, // Ensure the image fills the circular container
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Handle onTap event
                                    },
                                    child: Container(
                                      width:
                                          40, // Adjust width and height as needed
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color.fromARGB(255, 255,
                                              255, 255), // Border color
                                          width: 4, // Border width
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color.fromARGB(
                                                    255, 209, 209, 209)
                                                .withOpacity(
                                                    .3), // Shadow color
                                            // Blur radius
                                            offset: const Offset(
                                                0, 3), // Offset of the shadow
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/twlogo.png',
                                          width:
                                              30, // Adjust width and height as needed
                                          height: 30,
                                          fit: BoxFit
                                              .cover, // Ensure the image fills the circular container
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: (MediaQuery.of(context).size.width) / 15,
                          ),
                        ],
                      ),
                    ),
                  ],
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
            ),
          )),
    );
  }
}
