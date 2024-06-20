import 'dart:convert';

class Paypal {
  String? name;
  int? quantity;
  int? price;
  String? currency;

  Paypal(
      {required this.name,
      required this.quantity,
      required this.price,
      required this.currency});
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'currency': currency
    };
  }

  factory Paypal.fromMap(Map<String, dynamic> map) {
    return Paypal(
        name: map['name'] ?? '',
        price: map['price'] ?? 1,
        quantity: map['quantity'] ?? 1,
        currency: map['currency'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory Paypal.fromJson(String source) => Paypal.fromMap(json.decode(source));

  @override
  String toString() =>
      //'"name":"$name","quantity":"$quantity","price":"$price","currency":"$currency"';
      'name: $name,quantity: $quantity, price: $price,currency: $currency';
}
