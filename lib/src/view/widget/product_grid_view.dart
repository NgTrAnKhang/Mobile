import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/model/productnew.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_flutter/src/view/animation/open_container_wrapper.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({
    super.key,
    required this.items,
    //required this.likeButtonPressed,
  });

  final List<ProNew> items;
  //final void Function(int index) likeButtonPressed;

  Future<List<ProNew>> _getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository()
        .getProduct(prefs.getString('token').toString());
  }

  Widget _gridItemBody(ProNew product, int index) {
    Future<List<ProNew>> future;
    future = _getProducts();
    return FutureBuilder<List<ProNew>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // Image border
              child: SizedBox.fromSize(
                size: const Size.fromRadius(200), // Image radius
                child: Image.network(
                  product.getImageUrl(API().baseUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Positioned(
            //   top: -10,
            //   right: -20,
            //   child: LikeButton(
            //     size: 80,
            //     likeBuilder: (bool isLiked) {
            //       return IconButton(
            //         icon: Icon(
            //           Icons.favorite,
            //           color: items[index].isFavorite
            //               ? Colors.redAccent
            //               : const Color(0xFFA6A3A0),
            //         ),
            //         onPressed: () => likeButtonPressed(index),
            //       );
            //     },
            //   ),
            // )
          ],
        );
      },
    );
  }

  Widget _gridItemFooter(ProNew pro, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        padding: const EdgeInsets.all(5),
        height: 60,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Text(
                  pro.title.toString(),
                  overflow: TextOverflow.clip,
                  maxLines: 1,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 10),
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                NumberFormat('#,##0').format(pro.price) + " VNĐ",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 10 / 16,
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (_, index) {
          ProNew product = items[index];
          product.quantity = 1;
          return OpenContainerWrapper(
            product: product,
            child: GridTile(
              footer: _gridItemFooter(product, context),
              child: _gridItemBody(product, index),
            ),
          );
        },
      ),
    );
  }
}
