class BillModel {
  final String shippingAddress;
  final String phone;
  final double totalPrice;
  final DateTime paidDate;
  final int id;

  BillModel({
    required this.shippingAddress,
    required this.phone,
    required this.totalPrice,
    required this.paidDate,
    required this.id,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      shippingAddress: json['shippingAddress'],
      phone: json['phone'],
      totalPrice: json['totalPrice'],
      paidDate: DateTime.parse(json['paidDate']),
      id: json['id'],
    );
  }
}

class BillDetailModel {
  int id;
  String bookName;
  double price;
  int quantity;

  BillDetailModel({
    required this.id,
    required this.bookName,
    required this.price,
    required this.quantity,
  });

  factory BillDetailModel.fromJson(Map<String, dynamic> json) =>
      BillDetailModel(
        id: json["id"] ?? 0,
        bookName: json["bookName"] ?? "",
        price: json["price"] ?? 0,
        quantity: json["quantity"] ?? 0,
      );
}
