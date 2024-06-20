class UpdateModel {
  final int customerId;
  final String password;
  final String avatar;
  final String phone;
  final String address;
  final String dob;
  final String fullName;

  UpdateModel({
    required this.customerId,
    required this.password,
    required this.avatar,
    required this.phone,
    required this.address,
    required this.dob,
    required this.fullName,
  });

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      customerId: json['customerId'],
      password: json['password'],
      avatar: json['avatar'],
      phone: json['phone'],
      address: json['address'],
      dob: json['dob'],
      fullName: json['fullName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'password': password,
      'avatar': avatar,
      'phone': phone,
      'address': address,
      'dob': dob,
      'fullName': fullName,
    };
  }
}
