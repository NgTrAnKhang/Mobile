import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/data/sharepre.dart';
import 'package:e_commerce_flutter/src/view/screen/OTP_login.dart';
import 'package:e_commerce_flutter/src/view/screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animate_do/animate_do.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String url = 'https://www.youtube.com/watch?v=v15roNKlANU';
  late YoutubePlayerController ytbcontroller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags:
          const YoutubePlayerFlags(mute: false, loop: true, autoPlay: false));

  // Function to handle login logic
  Future<void> login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      // Show error dialog if username or password is empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Đăng nhập thất bại"),
            content: const Text("Thông tin đăng nhập không được để trống!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await APIRepository().login(username, password);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      int id = prefs.getInt('id')!;
      String temp = prefs.getString('token')!;
      var user = await APIRepository().current(id, temp);

      // Save user data locally
      saveUser(user);
      savemail(username);
      savepass(password);

      // Navigate to OTPLogin screen after successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const OTPLogin()),
      );
    } catch (e) {
      // Show error dialog if login fails
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Đăng nhập thất bại"),
            content: const Text("Thông tin đăng nhập sai. Vui lòng nhập lại!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Header Image and Text
            Container(
              height: MediaQuery.of(context).size.width / 1.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Center(
                          child: Text(
                            "Đăng nhập",
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                  color: Color.fromARGB(255, 231, 231, 231),
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            // Welcome Text
            const SizedBox(height: 20),
            FadeInUp(
              duration: const Duration(milliseconds: 1750),
              child: const Text(
                'Chào mừng trở lại!',
                style: TextStyle(
                  fontSize: 30,
                  color: Color.fromRGBO(71, 71, 71, 1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Email and Password Input Fields
            Padding(
              padding: const EdgeInsets.all(30),
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
                          color: const Color.fromRGBO(68, 143, 255, 1),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(68, 143, 255, .3),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          // Email Input Field
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(68, 143, 255, 1),
                                ),
                              ),
                            ),
                            child: TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),

                          // Password Input Field
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Mật khẩu",
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Login Button
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: ElevatedButton(
                      onPressed: () => login(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(68, 143, 255, 1),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),

                  // Sign Up Button
                  const SizedBox(height: 20),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        );
                      },
                      child: const Text(
                        'Chưa có tài khoản? Đăng ký ngay!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 2000),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupPage()),
                        );
                      },
                      child: Youtubebuild(context),
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

Widget Youtubebuild(BuildContext context) {
  String url = 'https://www.youtube.com/watch?v=yMst1kBOgr0';
  late YoutubePlayerController ytbcontroller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags:
          const YoutubePlayerFlags(mute: false, loop: true, autoPlay: false));

  return SizedBox(
    height: 250,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (BuildContext context, constraints) => YoutubePlayerBuilder(
          player: YoutubePlayer(controller: ytbcontroller),
          builder: (context, player) => SizedBox(
            height: 200,
            child: Scaffold(
              body: ListView(
                children: [player],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
