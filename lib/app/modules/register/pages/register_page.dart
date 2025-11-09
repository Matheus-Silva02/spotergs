import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:spotergs/app/modules/register/controllers/register_controller.dart';

class RegisterPage extends GetView<RegisterController>
{
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [Text('Pagina de registro'),],
      ),
    );
  }

}