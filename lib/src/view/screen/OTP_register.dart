import 'package:flutter/material.dart';
import 'package:email_otp/email_otp.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPRegister extends StatefulWidget {
  const OTPRegister({super.key});

  @override
  _OTPRegisterState createState() => _OTPRegisterState();
}

class _OTPRegisterState extends State<OTPRegister> {
  TextEditingController otpController = TextEditingController();
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
      bool otpSent = await myauth.sendOTP();
      if (otpSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP đã được gửi đến email của bạn.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không thể gửi OTP. Vui lòng thử lại sau.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email không khả dụng. Vui lòng thử lại.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xác nhận OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nhập OTP',
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
                  Navigator.pop(context, true); // Return true if OTP verified
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
              ),
              child:
                  const Text('Xác nhận OTP', style: TextStyle(fontSize: 18.0)),
            ),
          ],
        ),
      ),
    );
  }
}
