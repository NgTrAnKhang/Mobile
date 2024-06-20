class BookModel {
  final String title;
  final double price;
  final int quantity;
  final String thumbNail;
  final String author;
  final List<BookImage> images;
  final String publisher;
  final String serieName;
  final String categoryName;
  final String description;
  final int id;

  BookModel({
    required this.title,
    required this.price,
    required this.quantity,
    required this.thumbNail,
    required this.author,
    required this.images,
    required this.publisher,
    required this.serieName,
    required this.categoryName,
    required this.description,
    required this.id,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'],
      price: json['price'],
      quantity: json['quantity'],
      thumbNail: json['thumbNail'],
      author: json['author'],
      images: List<BookImage>.from(
          json['images'].map((image) => BookImage.fromJson(image))),
      publisher: json['publisher'],
      serieName: json['serieName'],
      categoryName: json['categoryName'],
      description: json['description'],
      id: json['id'],
    );
  }
}

class BookImage {
  final String imageName;
  final int id;
  final String createdDate;
  final String? updatedDate;

  BookImage({
    required this.imageName,
    required this.id,
    required this.createdDate,
    required this.updatedDate,
  });

  factory BookImage.fromJson(Map<String, dynamic> json) {
    return BookImage(
      imageName: json['imageName'],
      id: json['id'],
      createdDate: json['createdDate'],
      updatedDate: json['updatedDate'],
    );
  }
}
