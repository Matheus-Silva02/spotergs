import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotergs/app/core/consts.dart';
import 'package:spotergs/app/modules/register/models/register_model.dart';

class RegisterRepository {
  
Future<http.Response> registerUser(String userName, String password, String email) async{
  final uri = Uri.parse('${Consts.baseUrlBackend}/api/Auth/register');
  RegisterModel registerModel = RegisterModel(userName: userName, password: password, email: email,);
  try {
     var response = await http.post(uri,body: registerModel);

  return response;
  } catch (e) {
      return http.Response(jsonEncode({'error': e.toString()}), 500, headers: {'Content-Type':'application/json'});
  }
 
}

}