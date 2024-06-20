import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:e_commerce_flutter/src/model/productnew.dart';
import 'package:e_commerce_flutter/src/model/user.dart';
import 'package:e_commerce_flutter/src/controller/product_controller.dart';
import 'package:e_commerce_flutter/src/view/widget/menu_left.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid_view.dart';
import 'package:e_commerce_flutter/core/app_data.dart';

final ProductController controller = Get.put(ProductController());

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String? name;
  List<ProNew> products = [];

  bool isClicked = false;
  final TextEditingController searchController = TextEditingController();
  Future<List<ProNew>> _fetchProducts() async {
    controller.getpro();
    return controller.getall;
  }

  User user = User.userEmpty();
  Future<void> getDataUser() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String userString = pref.getString('user') ?? '{}';
      user = User.fromJson(jsonDecode(userString));
      setState(() {
        name = user.fullname;
      });
    } catch (e) {
      // Handle exceptions
      print("Error fetching user data: $e");
    }
  }

  Future<void> getProList() async {
    try {
      controller.getpro();
      List<ProNew> templst = controller.getall;
      print(templst);
      setState(() {
        products = templst;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Widget _buildRecommendedProductListView(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: AppData.recommendedProducts.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              width: 300,
              decoration: BoxDecoration(
                color: AppData.recommendedProducts[index].cardBackgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Giảm đến 30% \nMùa hè',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppData.recommendedProducts[index]
                                .buttonBackgroundColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            "Xem ngay",
                            style: TextStyle(
                              color: AppData
                                  .recommendedProducts[index].buttonTextColor!,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/shopping.png',
                    height: 125,
                    fit: BoxFit.cover,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
    getProList();
    controller.getpro();
    products = controller.getall;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                isClicked = !isClicked;
                if (isClicked) {
                  products = [];
                } else {
                  controller.getpro();
                }
              });

              if (!isClicked) {
                controller.getpro();
                setState(() {
                  products = controller.getall;
                });
              }
            },
            icon: Icon(isClicked ? Icons.close : Icons.search),
          )
        ],
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blue,
        title: isClicked
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: searchController,
                  onChanged: (context) {
                    print(context);
                    if (context != '') {
                      setState(() {
                        controller.getprokeyword(context);
                        products = controller.getall;
                      });
                    }
                    // ignore: unnecessary_null_comparison
                    if (context == '' || context == null) {
                      setState(() {
                        controller.getpro();
                        products = controller.getall;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 9),
                      hintText: 'Tìm kiếm'),
                ),
              )
            : Image.asset(
                'assets/images/light.png',
                fit: BoxFit.contain,
                height: 50,
              ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const MenuLeft(),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: () async {
          getDataUser();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Xin chào, ${name ?? ''}",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    "Bạn muốn mua gì?",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  _buildRecommendedProductListView(context),
                  GetBuilder(builder: (ProductController controller) {
                    return ProductGridView(
                      items: products,
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
