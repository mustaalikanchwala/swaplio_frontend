import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../core/constants.dart';
class AuthService {
  Future<Map<String,dynamic>> login(String email,String pass) async{
    final response = await http.post(
        Uri.parse(Constants.baseUrl + "/auth/login"),
        headers: <String,String>{
          'Content-Type': 'application/json'
        },
      body: jsonEncode(<String,String>{
        "email": email,
        "password": pass
      })
    );
    final data = jsonDecode(response.body);
    if(response.statusCode == 200){
      return data;
    }else {
      throw new Exception(data["message"] ?? "Invalid Email or Password");
    }
  }

  Future<Map<String,dynamic>> register(String fullName,String email,String password,String phoneNumber,String institution) async{
    final response = await http.post(
      Uri.parse(Constants.baseUrl+"/auth/register"),
      headers: <String,String>{
        'Content-Type': 'application/json'
      },
      body: jsonEncode(<String,String>{
        "email": email,
        "password": password,
        "fullName": fullName,
        "phoneNumber": phoneNumber,
        "institution": institution
      })
    );
    final data = jsonDecode(response.body);
    if(response.statusCode == 200){
      return data;
    }else {
      throw new Exception(data["message"] ?? "Invalid Email or Password");
    }
  }
}