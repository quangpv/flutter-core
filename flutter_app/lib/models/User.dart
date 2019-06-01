import 'package:flutter_app/core/Serializable.dart';

class User implements Serializable {
  int id = 0;
  String email = "";
  String name = "";
  String phone = "";

  User({this.email, this.name, this.id, this.phone});

  factory User.from(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
      );

  @override
  Map<String, dynamic> toMap() => {
        "id": id,
        "email": email,
        "name": name,
        "phone": phone,
      };
}
