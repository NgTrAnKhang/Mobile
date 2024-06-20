import 'dart:convert';
import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/data/sqlite.dart';
import 'package:e_commerce_flutter/src/model/cart.dart';
import 'package:e_commerce_flutter/src/model/notification_service.dart';
import 'package:e_commerce_flutter/src/model/request.dart';
import 'package:e_commerce_flutter/src/model/user.dart';
import 'package:e_commerce_flutter/src/view/animation/animated_switcher_wrapper.dart';
import 'package:e_commerce_flutter/src/view/screen/payment_screen.dart';
import 'package:e_commerce_flutter/src/view/widget/empty_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../controller/product_controller.dart';

final ProductController controller = Get.put(ProductController());

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  NotificationService notificationService = NotificationService();
  int id = 0;

  List<Cart> lstcart = [];
  User user = User.userEmpty();
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;
    user = User.fromJson(jsonDecode(strUser));
    setState(() {
      id = user.id as int;
    });
  }

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  num? count = 0;
  int? paypalprice = 0;

  Future<List<Cart>> _getProducts() async {
    return await _databaseHelper.products(id);
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

  void addbook() async {
    List<Cart> temp = await _databaseHelper.products(id);
    setState(() {
      lstcart = temp;
    });
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

  @override
  void initState() {
    super.initState();
    getDataUser();
    test().then((value) {
      setState(() {
        count = value;
      });
    });
    addbook();
    notificationService.initNotification();
  }

  Widget bottomBarTitle() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Tổng tiền:",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          AnimatedSwitcherWrapper(
            child: Text(
              "${NumberFormat('#,##0').format(count)} vnd",
              key: ValueKey<num?>(count),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomBarButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15), backgroundColor: Colors.blue),
          onPressed: () async {
            addbook();
            SharedPreferences pref = await SharedPreferences.getInstance();
            PaypalSuccessRequest request = PaypalSuccessRequest(
              orderItems: [],
              customerId: id,
            );

            // Iterate over lstcart and create OrderItem objects
            for (var product in lstcart) {
              OrderItem orderItem = OrderItem(
                quantity: product.count,
                bookId: product.id,
              );
              request.orderItems.add(orderItem);
            }
            for (var item in request.orderItems) {
              print('  Book ID: ${item.bookId}, Quantity: ${item.quantity}');
            }
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PaymentMethodsScreen()));
            String result = pref.getString('payres')!;
            print(result);
            if (result == 'true') {
              await APIRepository().addBill(request, pref.getString('token')!);
              for (var i in lstcart) {
                setState(() {
                  DatabaseHelper().deleteProduct(i.id, id);
                  count = count! - ((i.price ?? 0) * i.count);
                });
              }
            }
          },
          child: const Text(
            "Mua ngay",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget cartList() {
    return Expanded(
      flex: 11,
      child: FutureBuilder<List<Cart>>(
        future: _getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final itemProduct = snapshot.data![index];
                return _buildProduct(itemProduct, context);
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool> checkEmpty() async {
    Future<List<Cart>> futureList =
        _getProducts(); // Replace with your own future

    List<Cart> resultList = await futureList;
    if (resultList.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: FutureBuilder<bool>(
            future: checkEmpty(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final bool isEmpty = snapshot.data ?? true;
                if (isEmpty) {
                  return const EmptyCart();
                } else {
                  return cartList();
                }
              }
            },
          ),
        ),
        bottomBarTitle(),
        bottomBarButton()
      ],
    );
  }

  Widget _buildProduct(Cart pro, BuildContext context) {
    return Dismissible(
      key: Key(pro.id.toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        bool confirmDelete = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text('Xoá sản phẩm khỏi giỏ hàng?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Xoá'),
                ),
              ],
            );
          },
        );

        return confirmDelete;
      },
      onDismissed: (direction) {
        setState(() {
          DatabaseHelper().deleteProduct(pro.id, id);
          count = count! - ((pro.price ?? 0) * pro.count);
        });
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[200]?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Wrap(
          spacing: 30,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Image.network(
                      pro.img,
                      width: 100,
                      height: 90,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pro.title.toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${NumberFormat('#,##0').format(pro.price)} vnd',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    splashRadius: 10.0,
                    onPressed: () async {
                      setState(() {
                        DatabaseHelper().minus(pro, id);
                        count = count! - (pro.price ?? 0);
                      });
                    },
                    icon: const Icon(
                      Icons.remove,
                      color: Color.fromARGB(255, 21, 95, 156),
                    ),
                  ),
                  Text(
                    pro.count.toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    splashRadius: 10.0,
                    onPressed: () => setState(() {
                      DatabaseHelper().add(pro, id);
                      count = count! + (pro.price ?? 0);
                    }),
                    icon: const Icon(Icons.add,
                        color: Color.fromARGB(255, 21, 95, 156)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
