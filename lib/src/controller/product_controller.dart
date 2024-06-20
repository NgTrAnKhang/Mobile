import 'package:e_commerce_flutter/src/data/api.dart';
import 'package:e_commerce_flutter/src/model/productnew.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:e_commerce_flutter/core/app_data.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:e_commerce_flutter/src/model/product_category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductController extends GetxController {
  List<Product> allProducts = AppData.productss;
  RxList<Product> filteredProducts = AppData.productss.obs;
  RxList<ProNew> cartProducts = <ProNew>[].obs;
  RxList<ProductCategory> categories = AppData.categories.obs;
  RxInt totalPrice = 0.obs;
  List<ProNew> getall = [];
  List<String> namepro = [];
  //List<ProNew> allProductsnew = AppData.products;
  //RxList<ProNew> filteredProductsnew = AppData.products.obs;
  void getpro() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var temp =
          await APIRepository().getProduct(prefs.getString('token').toString());
      getall = temp;
      print(getall);
    } catch (e) {
      print(e);
    }
  }

  void getprokeyword(String keyword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp = await APIRepository()
        .getProductsByKeyword(prefs.getString('token').toString(), keyword);
    getall = temp;
    print(getall);
  }

  List<ProNew> getpro2() {
    getpro();
    return getall;
  }

  List<ProNew> getpro2keyword(String keyword) {
    getprokeyword(keyword);
    return getall;
  }

  List<ProNew> getpro3(int id) {
    getpro();
    getall.removeWhere((element) => element.id == id);
    return getall;
  }

  Future<List<ProNew>> allpro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var temp =
        await APIRepository().getProduct(prefs.getString('token').toString());
    getall = temp;
    return temp;
    // setState(() {
    //   test = temp;
    // });
  }

  void filterItemsByCategory(int index) {
    for (ProductCategory element in categories) {
      element.isSelected = false;
    }
    categories[index].isSelected = true;

    if (categories[index].type == ProductType.all) {
      filteredProducts.assignAll(List.from(getall));
    } else {
      filteredProducts.assignAll(allProducts.where((item) {
        return item.type == categories[index].type;
      }).toList());
    }
    update();
  }

  void isFavorite(int index) {
    filteredProducts[index].isFavorite = !filteredProducts[index].isFavorite;
    update();
  }

  void addToCart(ProNew product) {
    product.quantity = 1;
    print(product.quantity);

    cartProducts.add(product);
    cartProducts.assign(product);
    print(cartProducts.length);
    calculateTotalPrice();
  }

  void increaseItemQuantity(ProNew product) {
    product.quantity = product.quantity! + 1;
    calculateTotalPrice();
    update();
  }

  void decreaseItemQuantity(ProNew product) {
    //
    if (product.quantity! == 1) {
      cartProducts.remove(product);
    }
    product.quantity = product.quantity! - 1;
    calculateTotalPrice();
    update();
  }

  bool isPriceOff(Product product) => product.off != null;

  bool get isEmptyCart => cartProducts.isEmpty;

  bool isNominal(Product product) => product.sizes?.numerical != null;

  void calculateTotalPrice() {
    totalPrice.value = 0;
    for (var element in cartProducts) {
      totalPrice.value += element.quantity!.toInt() * element.price!.toInt();
    }
  }

  getFavoriteItems() {
    filteredProducts.assignAll(
      allProducts.where((item) => item.isFavorite),
    );
  }

  getCartItems() {
    cartProducts.assignAll(
      getall.where((item) => item.quantity! > 0),
    );
  }

  removeCartItems() {
    cartProducts.remove(
      getall.where((item) => item.quantity! == 0),
    );
  }

  getAllItems() {
    filteredProducts.assignAll(allProducts);
  }
}
