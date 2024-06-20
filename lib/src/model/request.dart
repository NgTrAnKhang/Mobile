class PaypalSuccessRequest {
  List<OrderItem> orderItems;
  int customerId;

  PaypalSuccessRequest({required this.orderItems, required this.customerId});

  factory PaypalSuccessRequest.fromJson(Map<String, dynamic> json) {
    return PaypalSuccessRequest(
      orderItems: List<OrderItem>.from(
          json['orderItems'].map((item) => OrderItem.fromJson(item))),
      customerId: json['customerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderItems': orderItems.map((item) => item.toJson()).toList(),
      'customerId': customerId,
    };
  }
}

class OrderItem {
  int quantity;
  int bookId;

  OrderItem({required this.quantity, required this.bookId});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      quantity: json['quantity'],
      bookId: json['bookId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'bookId': bookId,
    };
  }
}
