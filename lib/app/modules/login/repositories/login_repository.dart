import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotergs/app/core/consts.dart';
import 'package:spotergs/app/modules/login/models/login_model.dart';

class LoginRepository {
  
Future<http.Response> loginUser(String email, String password) async{
  final uri = Uri.parse('${Consts.baseUrlBackend}/api/Auth/login');
  LoginModel loginModel = LoginModel(email: email, password: password);
  try {
     var response = await http.post(
       uri,
       headers: {'Content-Type': 'application/json'},
       body: jsonEncode(loginModel.toJson()),
     );

  return response;
  } catch (e) {
      return http.Response(jsonEncode({'error': e.toString()}), 500, headers: {'Content-Type':'application/json'});
  }
 
}

}
