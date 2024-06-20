import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_flutter/src/model/notification_service.dart';
import 'package:e_commerce_flutter/src/view/screen/home_screen.dart';

class OTPLogin extends StatefulWidget {
  const OTPLogin({super.key});

  @override
  State<OTPLogin> createState() => _OTPLoginState();
}

class _OTPLoginState extends State<OTPLogin> {
  TextEditingController otpController = TextEditingController();
  NotificationService notificationService = NotificationService();
  EmailOTP myauth = EmailOTP();

  @override
  void initState() {
    super.initState();
    sendOTP();
  }

  void sendOTP() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? mail = pref.getString('mail');
    if (mail != null && mail.isNotEmpty) {
      myauth.setConfig(
        appEmail: "me@BookStore.com",
        appName: "BookStore",
        userEmail: mail,
        otpLength: 6,
        otpType: OTPType.digitsOnly,
      );
      if (await myauth.sendOTP()) {
        notificationService.sendNotification(
          title: "BookStore",
          body: 'OTP đã được gửi đến email của bạn',
        );
      }
    } else {
      // Xử lý trường hợp email không khả dụng
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Xác thực OTP'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Vui lòng nhập OTP đã được gửi đến email của bạn:',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nhập OTP',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
                maxLength: 6,
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  bool isVerified =
                      await myauth.verifyOTP(otp: otpController.text);
                  if (isVerified) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Đăng nhập thành công'),
                          content: const Text(
                              'Chào mừng bạn đã đăng nhập thành công!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Đóng dialog
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('OTP không hợp lệ. Vui lòng thử lại.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Xác thực',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
