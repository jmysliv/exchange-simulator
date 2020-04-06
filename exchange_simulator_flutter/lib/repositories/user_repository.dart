import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:exchange_simulator_flutter/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository{
  String _token;
  static const url = "http://localhost:8080";
  UserRepository(){
    this._token = null;
  }

  Map<String, String> setUpHeaders(){
    if( this._token == null){
      return {'Content-Type': 'application/json'};
    } else {
      return {'Content-Type': 'application/json', 'Authorization': 'Bearer $_token'};
    }
  }

  Future<void> login(String email, String password) async {
    UserToAuth userToAuth = UserToAuth(email, password);
    final response = await http.post(url + "/auth/login", headers: this.setUpHeaders(), body: userToAuth.toJson());
    if(response.statusCode == 200){
      this._token = jsonDecode(response.body)['token'];
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("token", this._token);
    } else if(response.statusCode == 400){
      throw Exception(jsonDecode(response.body)['message']);
    } else{
      throw Exception("Failed to authenticate");
    }
  }

  Future<void> register(String email, String name, String password) async{
    UserToRegister userToRegister = UserToRegister(name, email, password);
    final response = await http.post(url + "/auth/register", headers: this.setUpHeaders(), body: userToRegister.toJson());
    if(response.statusCode == 201){
      await login(email, password);
    } else if(response.statusCode == 409){
      throw Exception("Istnieje użytkownik o podanym emailu");
    } else if(response.statusCode == 400){
      throw Exception(jsonDecode(response.body)['message']);
    } else{
      throw Exception("Failed to create account");
    }
  }

  Future<List<User>> fetchUsers() async{
    final response = await http.get(url + "/users", headers: this.setUpHeaders());
    if(response.statusCode == 200){
      List<User> users = (jsonDecode(response.body) as List).map((user) => User.fromJson(user)).toList();
      return users;
    }else{
      throw Exception("Failed to fetch users");
    }
  }

  Future<User> fetchMe() async{
    final response = await http.get(url + "/users/me", headers: this.setUpHeaders());
    if(response.statusCode == 200){
      User user = User.fromJson(jsonDecode(response.body));
      return user;
    }else{
      throw Exception("Failed to fetch me");
    }
  }

  Future<void> signOut() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("token", null);
    this._token = null;
  }

  Future<bool> isSignedIn() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    this._token = preferences.getString('token');
    return this._token != null;
  }

}