class User {
  int? id;
  String? fullname;
  String? address;
  String? phone;
  String? avatar;
  String? gender;
  DateTime? dob;

  User({
    required this.id,
    required this.fullname,
    required this.address,
    required this.phone,
    required this.avatar,
    required this.gender,
    required this.dob,
  });
  static User userEmpty() {
    return User(
        id: 0,
        fullname: '',
        address: '',
        phone: '',
        avatar: '',
        gender: '',
        dob: null);
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        fullname: json["fullName"],
        address: json["address"],
        phone: json["phone"],
        avatar: json["avatar"],
        gender: json["gender"],
        dob: DateTime.parse(json["dob"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullName'] = fullname;
    data['address'] = address;
    data['phone'] = phone;
    data['avatar'] = avatar;
    data['gender'] = gender;
    data['dob'] = dob?.toIso8601String();

    return data;
  }
}
