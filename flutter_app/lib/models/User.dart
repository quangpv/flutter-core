class User extends Object {
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

  toMap() => <String, dynamic>{
        "id": id,
        "email": email,
        "name": name,
        "phone": phone,
      };
}
