class ProNew {
  String? title;
  num? price;
  String? description;
  String? serie;
  String? category;
  String? publisher;
  int? quantity;
  String? imageName; // Add a new property for imageName
  int? totalPage;
  String? author;
  int? id;
  String? thumbNail;

  ProNew({
    required this.title,
    required this.price,
    required this.description,
    required this.serie,
    required this.category,
    required this.publisher,
    required this.quantity,
    required this.imageName, // Add imageName to the constructor
    required this.totalPage,
    required this.author,
    required this.id,
    required this.thumbNail,
  });

  factory ProNew.fromJson(Map<String, dynamic> json) {
    return ProNew(
      title: json["title"],
      price: json["price"],
      description: json["description"],
      serie: json["serieName"],
      category: json["categoryName"],
      publisher: json["publisher"],
      quantity: json["quantity"],
      imageName: json["images"][0]
          ["imageName"], // Set the imageName from the API response
      totalPage: json["totalPage"],
      author: json["author"],
      id: json["id"],
      thumbNail: json['thumbNail'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'quantity': quantity,
      'thumbNail': thumbNail,
      'author': author,
      'images': imageName,
      'publisher': publisher,
      'serieName': serie,
      'categoryName': category,
      'description': description,
      'id': id,
    };
  }

  String getImageUrl(String baseurl) {
    if (imageName != null) {
      return "$baseurl/imgs/$imageName";
    }
    return ""; // Return a default or placeholder image URL if the imageName is null
  }
}
