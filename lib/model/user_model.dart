class UserModel {
  String uid;
  String email;
  String name;
  String phone;
  String active;
  String admin;
  String password;

  UserModel({this.uid, this.email, this.name, this.phone, this.active, this.admin, this.password});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['firstName'],
      phone: map['secondName'],
      active: map['active'],
      admin: map['admin'],
      password: map['password'],

    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'active': active,
      'admin': admin,
      'password': password
    };
  }
}