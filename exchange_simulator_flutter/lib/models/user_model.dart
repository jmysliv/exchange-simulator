import 'dart:convert';

class User{
  final String name;
  final String email;
  final String id;
  final double amountOfPLN;

  User(this.name, this.id, this.email, this.amountOfPLN);

  User.fromJson(Map<String, dynamic> json)
    : this.name = json['name'],
      this.email = json['email'],
      this.id = json['_id'],
      this.amountOfPLN = json['amountOfPLN'];

  String toJson() =>
    jsonEncode({
      "_id": "$id",
      "amountOfPLN": "$amountOfPLN",
      "name": "$name",
      "email": "$email"
    });

  @override
  String toString() => '{ id: $id, name: $name, email: $email, amountOfPLN: $amountOfPLN}';


}

class UserToRegister{
  final String name;
  final String email;
  final String password;

  UserToRegister(this.name, this.email, this.password);

  String toJson() =>
      jsonEncode({
        "password": "$password",
        "name": "$name",
        "email": "$email"
      });

  @override
  String toString() => '{ password: $password, name: $name, email: $email}';
}

class UserToAuth{
  final String email;
  final String password;

  UserToAuth(this.email, this.password);

  String toJson() =>
      jsonEncode({
        "password": "$password",
        "email": "$email"
      });

  @override
  String toString() => '{ password: $password, email: $email}';

}