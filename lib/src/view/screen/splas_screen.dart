import 'package:e_commerce_flutter/src/view/screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() async {
    // Delay for 3 seconds
    Duration duration = Duration(seconds: 3);
    await Future.delayed(duration);

    // Navigate to the new screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxWidthPercentage = 0.8;
    final maxWidth = screenWidth * maxWidthPercentage;
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(bottom: 40),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'GOBook',
                style: TextStyle(
                  fontSize: 50,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2.0,
                      color: Color.fromARGB(255, 21, 95, 156),
                    ),
                  ],
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Image.asset(
                'assets/images/img.jpg', // Replace 'assets/your_image.png' with the path to your image
                height: 300, // Adjust the height of the image
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
