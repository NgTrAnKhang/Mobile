import 'dart:convert';

import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/data/sharepre.dart';
import 'package:e_commerce_flutter/src/data/sqlite.dart';
import 'package:e_commerce_flutter/src/model/cart.dart';
import 'package:e_commerce_flutter/src/model/productnew.dart';
import 'package:e_commerce_flutter/src/model/user.dart';
import 'package:e_commerce_flutter/src/view/screen/payment_screen%20copy.dart';
import 'package:e_commerce_flutter/src/view/widget/carousel_slider.dart';
import 'package:e_commerce_flutter/src/view/widget/product_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/product_controller.dart';

final ProductController controller = Get.put(ProductController());

class ProductDetailScreen extends StatefulWidget {
  final ProNew product;

  const ProductDetailScreen(this.product, {super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  User? user;
  int? userId;
  int? selectedQuantity = 1;
  late bool _isMounted;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _loadUserData();
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');
    if (_isMounted && userData != null) {
      user = User.fromJson(jsonDecode(userData));
      userId = user!.id;
      setState(() {});
    }
  }

  void _addToCart(ProNew pro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Chọn số lượng"),
          content: DropdownButtonFormField<int>(
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 50, color: Colors.white))),
            value: selectedQuantity,
            items: List.generate(10, (index) => index + 1)
                .map((item) => DropdownMenuItem<int>(
                      value: item,
                      child: Text(item.toString(),
                          style: const TextStyle(fontSize: 20)),
                    ))
                .toList(),
            onChanged: (item) => setState(() => selectedQuantity = item),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                print(selectedQuantity);
                _onSave(pro, selectedQuantity.toString());
                Navigator.of(context).pop();
              },
              child: const Text("Thêm vào giỏ hàng"),
            ),
          ],
        );
      },
    );
  }

  final DatabaseHelper _databaseService = DatabaseHelper();
  Future<void> _onSave(ProNew pro, String quantity) async {
    bool result = await _databaseService.hasData(pro.id!, userId!);
    print(result);
    _databaseService.insert2(
        Cart(
            id: pro.id!,
            title: pro.title!,
            price: pro.price,
            img: pro.getImageUrl(API().baseUrl),
            count: int.tryParse(quantity)!,
            user: userId!),
        userId!);
  }

  void _addToCartWithQuantity(int quantity) {
    if (userId != null) {
      Cart cartItem = Cart(
        id: widget.product.id!,
        title: widget.product.title!,
        price: widget.product.price,
        img: widget.product.getImageUrl(API().baseUrl),
        count: quantity,
        user: userId!,
      );
      DatabaseHelper().insertProduct(cartItem);

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Thành công"),
            content: const Text("Sản phẩm đã được thêm vào giỏ hàng."),
            actions: [
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
    } else {
      // Handle the case when userId is null, maybe show a message to the user
      print("User is not logged in.");
    }
  }

  Widget _buildProductPageView() {
    List<String> imgUrl = [widget.product.getImageUrl(API().baseUrl)];
    return Container(
      padding: const EdgeInsets.only(top: 25),
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(40),
          bottomLeft: Radius.circular(40),
        ),
      ),
      child: CarouselSlider(items: imgUrl),
    );
  }

  Widget _buildProductDescription() {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  currencyFormat.format(widget.product.price),
                  style: const TextStyle(color: Colors.red, fontSize: 20),
                ),
              ),
              const FavoriteButton(),
            ],
          ),
          const SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Thông tin sản phẩm",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(
                'Tên tác giả: ${widget.product.author!}',
                style: const TextStyle(fontSize: 18),
              ),
              Text('Thể loại: ${widget.product.category!}',
                  style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              const Text("Giới thiệu sản phẩm",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ReadMoreText(
                widget.product.description ?? '',
                trimCollapsedText: "Xem thêm",
                trimExpandedText: "Thu lại",
                style: const TextStyle(fontSize: 16),
                trimLines: 8,
                trimMode: TrimMode.Line,
                lessStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue),
                moreStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blue),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'Gợi ý cho bạn',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ProductGridView(
                  items: controller.getpro3(widget.product.id ?? 0)),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> imgUrl = [widget.product.getImageUrl(API().baseUrl)];
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              pinned: true,
              floating: false,
              expandedHeight: MediaQuery.of(context).size.height * 0.55,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 16),
                centerTitle: true,
                expandedTitleScale: 1.2,
                title: Text(
                  widget.product.title.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: CarouselSlider(items: imgUrl),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildProductDescription();
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: const BorderSide(width: 1, color: Colors.deepOrange),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
              ),
              onPressed: () {
                _addToCart(widget.product);
              },
              child: const Text(
                "Thêm vào giỏ hàng",
                style: TextStyle(color: Colors.deepOrange),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
              ),
              onPressed: () {
                String? temp = widget.product.price!.toString();
                //print(temp);
                savebuynow(temp);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const BuyNowScreen())); // Add to cart when pressed "Mua ngay"
              },
              child: const Text(
                "Mua ngay",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isFavorite = false;
  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_isFavorite);
    return IconButton(
      icon: _isFavorite
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border),
      onPressed: _toggleFavorite,
      color: Colors.red, // Customize the color if needed
    );
  }
}
