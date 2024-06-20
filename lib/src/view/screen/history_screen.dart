import 'dart:convert';

import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/data/sharepre.dart';
import 'package:e_commerce_flutter/src/model/bill.dart';
import 'package:e_commerce_flutter/src/model/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'history_detail.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late User _user;
  late Future<List<BillModel>> _billsFuture;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userDataString = prefs.getString('user') ?? '{}';
    setState(() {
      _user = User.fromJson(jsonDecode(userDataString));
      _billsFuture = APIRepository().getHistory(_user.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<BillModel>>(
        future: _billsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Failed to load data'),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final bill = snapshot.data![index];
                return _buildBillWidget(bill, context);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBillWidget(BillModel bill, BuildContext context) {
    return InkWell(
      onTap: () async {
        var temp = await APIRepository().getHistoryDetail(bill.id.toString());
        saveBillID(bill.id.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryDetail(bill: temp),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mã đơn hàng: ${bill.id}',
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                NumberFormat('#,##0').format(bill.totalPrice),
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'Ngày mua: ${DateFormat('dd/MM/yy').format(bill.paidDate)}',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
