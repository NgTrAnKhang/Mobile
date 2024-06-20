import 'package:e_commerce_flutter/src/model/bottom_navy_bar_item.dart';
import 'package:e_commerce_flutter/src/model/productnew.dart';
import 'package:e_commerce_flutter/src/model/recommended_product.dart';
//import 'package:e_commerce_flutter/src/model/product_size_type.dart';
import 'package:e_commerce_flutter/src/model/product_category.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:e_commerce_flutter/src/model/categorical.dart';
//import 'package:e_commerce_flutter/src/model/numerical.dart';
import 'package:e_commerce_flutter/src/model/product.dart';
import 'package:flutter/material.dart';

class AppData {
  const AppData._();

  static String dummyText =
      'Lorem Ipsum is simply dummy text of the printing and typesetting'
      ' industry. Lorem Ipsum has been the industry\'s standard dummy text'
      ' ever since the 1500s, when an unknown printer took a galley of type'
      ' and scrambled it to make a type specimen book.'
      'Lorem Ipsum is simply dummy text of the printing and typesetting'
      ' industry. Lorem Ipsum has been the industry\'s standard dummy text'
      ' ever since the 1500s, when an unknown printer took a galley of type'
      ' and scrambled it to make a type specimen book.'
      'Lorem Ipsum is simply dummy text of the printing and typesetting'
      ' industry. Lorem Ipsum has been the industry\'s standard dummy text'
      ' ever since the 1500s, when an unknown printer took a galley of type'
      ' and scrambled it to make a type specimen book.'
      'Lorem Ipsum is simply dummy text of the printing and typesetting'
      ' industry. Lorem Ipsum has been the industry\'s standard dummy text'
      ' ever since the 1500s, when an unknown printer took a galley of type'
      ' and scrambled it to make a type specimen book.'
      'Lorem Ipsum is simply dummy text of the printing and typesetting'
      ' industry. Lorem Ipsum has been the industry\'s standard dummy text'
      ' ever since the 1500s, when an unknown printer took a galley of type'
      ' and scrambled it to make a type specimen book.'
      'Lorem Ipsum is simply dummy text of the printing and typesetting'
      ' industry. Lorem Ipsum has been the industry\'s standard dummy text'
      ' ever since the 1500s, when an unknown printer took a galley of type'
      ' and scrambled it to make a type specimen book.';
  static List<ProNew> products = [];
  static List<Product> productss = [
    Product(
      name: 'Vượt Qua Thời Không Để Yêu Anh',
      price: 460,
      about: dummyText,
      isAvailable: true,
      off: 100,
      quantity: 0,
      images: [
        'assets/images/a1.jpg',
      ],
      isFavorite: false,
      rating: 4,
      type: ProductType.mobile,
    ),
    Product(
      name: 'Vượt Qua Thời Không Để Yêu Anh',
      price: 460,
      about: dummyText,
      isAvailable: true,
      off: 100,
      quantity: 0,
      images: [
        'assets/images/a1.jpg',
      ],
      isFavorite: false,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      name: 'Vượt Qua Thời Không Để Yêu Anh',
      price: 460,
      about: dummyText,
      isAvailable: true,
      off: 100,
      quantity: 0,
      images: [
        'assets/images/a1.jpg',
      ],
      isFavorite: false,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      name: 'Vượt Qua Thời Không Để Yêu Anh',
      price: 460,
      about: dummyText,
      isAvailable: true,
      off: 100,
      quantity: 0,
      images: [
        'assets/images/a1.jpg',
      ],
      isFavorite: false,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      name: 'Vượt Qua Thời Không Để Yêu Anh',
      price: 460,
      about: dummyText,
      isAvailable: true,
      off: 100,
      quantity: 0,
      images: [
        'assets/images/a1.jpg',
      ],
      isFavorite: false,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      name: 'Vượt Qua Thời Không Để Yêu Anh',
      price: 460,
      about: dummyText,
      isAvailable: true,
      off: 100,
      quantity: 0,
      images: [
        'assets/images/a1.jpg',
      ],
      isFavorite: false,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      name: 'Vượt Qua Thời Không Để Yêu Anh',
      price: 460,
      about: dummyText,
      isAvailable: true,
      off: 100,
      quantity: 0,
      images: [
        'assets/images/a1.jpg',
      ],
      isFavorite: false,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      name: 'Vượt Qua Thời Không Để Yêu Anh',
      price: 460,
      about: dummyText,
      isAvailable: true,
      off: 100,
      quantity: 0,
      images: [
        'assets/images/a1.jpg',
      ],
      isFavorite: false,
      rating: 1,
      type: ProductType.mobile,
    ),
  ];

  static List<ProductCategory> categories = [
    ProductCategory(
      ProductType.all,
      true,
      Icons.all_inclusive,
    ),
    ProductCategory(
      ProductType.mobile,
      false,
      FontAwesomeIcons.mobileScreenButton,
    ),
    ProductCategory(ProductType.watch, false, Icons.watch),
    ProductCategory(
      ProductType.tablet,
      false,
      FontAwesomeIcons.tablet,
    ),
    ProductCategory(
      ProductType.headphone,
      false,
      Icons.headphones,
    ),
    ProductCategory(
      ProductType.tv,
      false,
      Icons.tv,
    ),
  ];

  static List<Color> randomColors = [
    const Color(0xFFFCE4EC),
    const Color(0xFFF3E5F5),
    const Color(0xFFEDE7F6),
    const Color(0xFFE3F2FD),
    const Color(0xFFE0F2F1),
    const Color(0xFFF1F8E9),
    const Color(0xFFFFF8E1),
    const Color(0xFFECEFF1),
  ];

  static List<BottomNavyBarItem> bottomNavyBarItems = [
    BottomNavyBarItem(
      "Trang chủ",
      const Icon(Icons.home),
      Colors.blue,
      Colors.grey,
    ),
    BottomNavyBarItem(
      "Yêu thích",
      const Icon(Icons.favorite),
      Colors.blue,
      Colors.grey,
    ),
    BottomNavyBarItem(
      "Giỏ hàng",
      const Icon(Icons.shopping_cart),
      Colors.blue,
      Colors.grey,
    ),
    BottomNavyBarItem(
      "Hồ sơ",
      const Icon(Icons.person),
      Colors.blue,
      Colors.grey,
    ),
  ];

  static List<RecommendedProduct> recommendedProducts = [
    RecommendedProduct(
      imagePath: "",
      cardBackgroundColor: Colors.blue,
    ),
    RecommendedProduct(
      imagePath: "",
      cardBackgroundColor: Colors.blue,
      buttonBackgroundColor: const Color(0xFF9C46FF),
      buttonTextColor: Colors.white,
    ),
  ];
}
