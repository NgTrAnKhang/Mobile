import 'dart:convert';
import 'package:e_commerce_flutter/src/data/sharepre.dart';
import 'package:e_commerce_flutter/src/data/sqlite.dart';
import 'package:e_commerce_flutter/src/model/cart.dart';
import 'package:e_commerce_flutter/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_flutter/src/model/notification_service.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

enum PaymentMethod { paypal, momo }

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.paypal;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  NotificationService notificationService = NotificationService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  int? paypalprice = 0;
  num? count = 0;
  List<Cart> item = [];

  void _handleRadio(PaymentMethod? method) {
    if (method != null) {
      setState(() {
        _selectedMethod = method;
      });
    }
  }

  void _showFunctionalityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Chức năng đang phát triển'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  void _processPayment() {
    if (_selectedMethod == PaymentMethod.momo) {
      _showFunctionalityDialog(); // Show the alert dialog for Momo payment
    } else {
      Navigator.pushReplacementNamed(context, '/payment_confirmation');
    }
  }

  int id = 0;
  User user = User.userEmpty();
  Future<void> getDataUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String userString = pref.getString('user') ?? '{}';
      user = User.fromJson(jsonDecode(userString));
      setState(() {
        user = user;
        id = user.id as int;
      });
    } catch (e) {
      // Handle exceptions
      print("Error fetching user data: $e");
    }
  }

  Future<String> addList() async {
    List<Cart> temp = await _databaseHelper.products(id);

    List<Map<String, dynamic>> jsonList = temp.map((cart) {
      num? nullableNum = cart.price! / 23000;
      int? roundedInt = nullableNum!.round().toInt();
      if (roundedInt < 1) {
        roundedInt = 1;
      }
      return {
        "name": cart.title,
        "quantity": cart.count,
        "price": roundedInt.toString(),
        "currency": "USD"
      };
    }).toList();

    String encodedJson = json.encode(jsonList);
    if (encodedJson.startsWith('[') && encodedJson.endsWith(']')) {
      encodedJson = encodedJson.substring(1, encodedJson.length - 1);
    }
    return encodedJson;
  }

  String lstpay = '';

  Future<void> fetchTemp() async {
    String a;
    a = await addList();
    print(a);
    if (a.startsWith('[') && a.endsWith(']')) {
      a = a.substring(1, a.length - 1);
    }
    setState(() {
      lstpay = a;
    });
  }

  Future<void> changeprice() async {
    int? temprice = 0;
    List<Cart> temp = await _databaseHelper.products(id);
    for (var i in temp) {
      num? nullableNum = i.price! / 23000;
      int? roundedInt = nullableNum!.round().toInt();
      if (roundedInt < 1) {
        roundedInt = 1;
      }
      temprice = temprice! + roundedInt * i.count;
    }
    setState(() {
      paypalprice = temprice;
    });
  }

  Future<num> test() async {
    num temp1 = 0;
    List<Cart> temp = await _databaseHelper.products(id);
    for (var i in temp) {
      temp1 += i.price * i.count;
    }
    return temp1;
  }

  Future<List<Cart>> _getProducts() async {
    return await _databaseHelper.products(id);
  }

  final DatabaseHelper _databaseService = DatabaseHelper();
  Future<void> deletecart(int user) async {
    await _databaseService.deleteAll(user);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataUser();
    test().then((value) {
      setState(() {
        count = value;
      });
    });
    _getProducts().then((value) => setState(() {
          item = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    fetchTemp();
    changeprice();
    List<Map<String, dynamic>> transactions = [
      {
        "amount": {
          "total": paypalprice.toString(),
          "currency": "USD",
          "details": {
            "subtotal": paypalprice.toString(),
            "shipping": '0',
            "shipping_discount": 0
          }
        },
        "description": "The payment transaction description.",
        "item_list": {
          "items": [],
          "shipping_address": {
            "recipient_name": user.fullname,
            "line1": "63/1",
            "line2": "",
            "city": "HCM",
            "country_code": "VN",
            "postal_code": "700000",
            "phone": "+31459414",
            "state": ""
          },
        }
      }
    ];

    String transactionsString = json.encode(transactions);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thanh toán",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPaymentOption(
                size,
                PaymentMethod.paypal,
                'Paypal',
                'assets/images/paypal-logo.png',
              ),
              const SizedBox(height: 15),
              _buildPaymentOption(
                size,
                PaymentMethod.momo,
                'Momo',
                'assets/images/momo-logo.png',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Thông tin thanh toán',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Button to use default information
                  ElevatedButton(
                    onPressed: () {
                      _nameController.text = user.fullname.toString();
                      _phoneController.text = user.phone.toString();
                      _addressController.text = user.address.toString();
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      'Mặc định',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        NumberFormat('#,##0').format(count) + " vnd",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        color: Colors.white,
        child: Container(
          height: 80.0,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ElevatedButton(
            onPressed: () async {
              {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => PaypalCheckout(
                    sandboxMode: true,
                    clientId:
                        "AdYhF_tOvunZhWNOVur2zqb7jh72M1J-lkGbaLvYlzIhacwq3hyEZM1M8gso8aqT3fie6DcNRKQ5OpT_",
                    secretKey:
                        "EPm1nrRk4Db9-qNP8ESf0nbiAKLnCImUFPgWG6m0z3AhbLpZkwCXfjRFZNGzHMvE2jYNQomWdS5H5fjg",
                    returnURL: "success.snippetcoder.com",
                    cancelURL: "cancel.snippetcoder.com",
                    transactions: jsonDecode(transactionsString),
                    note: "Contact us for any questions on your order.",
                    onSuccess: (Map params) async {
                      print("onSuccess: $params");

                      String format = NumberFormat('#,##0').format(count);
                      notificationService.sendNotification(
                          title: "BookStore",
                          body: 'Thanh toán thành công số tiền $format vnd');
                      Navigator.pop(context, true);
                      savepaypalresult('true');
                    },
                    onError: (error) {
                      print("onError: $error");
                      Navigator.pop(context, false);
                      savepaypalresult('false');
                    },
                    onCancel: () {
                      print('cancelled:');
                      savepaypalresult('false');
                    },
                  ),
                ));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            child: const Text(
              'Thanh toán',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    Size size,
    PaymentMethod method,
    String name,
    String logoPath,
  ) {
    return Container(
      width: size.width,
      padding: const EdgeInsets.only(right: 20),
      height: 55,
      decoration: BoxDecoration(
        border: _selectedMethod == method
            ? Border.all(width: 1, color: Colors.red)
            : Border.all(width: 0.3, color: Colors.grey),
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Radio(
                  value: method,
                  groupValue: _selectedMethod,
                  onChanged: (val) => _handleRadio(val),
                  activeColor: Colors.red,
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color:
                        _selectedMethod == method ? Colors.black : Colors.grey,
                  ),
                ),
              ],
            ),
            Image.asset(
              logoPath,
              height: 30,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(
    String label,
    String quantity,
    String price,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              quantity,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Text(
          price,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
