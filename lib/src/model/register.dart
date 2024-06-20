class Register {
  String? fullname;
  String? address;
  String? phone;
  String? username;
  String? password;
  String? dob;
  String? gender;
  String? avatar;
  Register({
    required this.fullname,
    required this.address,
    required this.phone,
    required this.username,
    required this.password,
    required this.dob,
    required this.gender,
    required this.avatar,
  });
  static Register registerEmpty() {
    return Register(
        fullname: 'fullname',
        address: 'address',
        phone: 'phone',
        username: 'username',
        password: 'password',
        dob: 'dob',
        gender: 'gender',
        avatar: 'avatar');
  }
}
