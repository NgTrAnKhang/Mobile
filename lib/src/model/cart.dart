import 'dart:convert';

class Cart {
  int id;
  String title;
  dynamic price;
  String img;
  int count;
  int user;
  //constructor
  Cart(
      {required this.title,
      required this.price,
      required this.img,
      required this.count,
      required this.id,
      required this.user});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'img': img,
      'count': count,
      'id': id,
      'user': user
    };
  }

  factory Cart.fromMap(Map<String, dynamic> map) {
    return Cart(
        id: map['id'] ?? 0,
        title: map['title'] ?? '',
        price: map['price'] ?? '',
        img: map['img'] ?? '',
        count: map['count'] ?? 1,
        user: map['user'] ?? 1);
  }

  String toJson() => json.encode(toMap());

  factory Cart.fromJson(String source) => Cart.fromMap(json.decode(source));

  @override
  String toString() =>
      'Product(id: $id, title: $title, price: $price, img: $img, count: $count,user: $user)';
}
