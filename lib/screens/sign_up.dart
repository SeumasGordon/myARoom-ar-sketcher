import 'package:ar_sketcher/controllers/authController.dart';
import 'login_page.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components_ui/rounded_btn.dart';
import '../components_ui/rounded_input.dart';
import '../components_ui/text_field_container.dart';

// ignore: must_be_immutable
class SignUpPage extends GetWidget<AuthController> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _obscureText = true;

  // void _togglePasswordView() {
  //   setState(() {
  //     _obscureText = !_obscureText;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo_icon.png', height: 150, width: 150,).paddingOnly(bottom: 20.0),
                RoundedInputField(
                  hintText: "Name",
                  controller: nameController,
                  icon: Icon(Icons.person, color: Color(0xff1761a0))
                ),
                RoundedInputField(
                  hintText: "Email",
                  keyboard: TextInputType.emailAddress,
                  icon: Icon(Icons.email, color: Color(0xff1761a0)),
                  controller: emailController,
                ),
                TextFieldContainer(
                  child: TextFormField(
                    obscureText: _obscureText,
                    controller: passwordController,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: "Password",
                      icon: Icon(
                        Icons.lock,
                        color: Color(0xff1761a0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xff1761a0),
                        ),
                        onPressed: () {
                          _obscureText = !_obscureText;
                          (context as Element).markNeedsBuild();
                          /*_togglePasswordView();*/
                        },
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                RoundedButton(
                  color: Color(0xff1761a0),
                  textColor: Colors.white,
                  text: "SIGN UP",
                  press: () {
                    controller.createUser(nameController.text,
                        emailController.text, passwordController.text);
                  },
                ),
                FlatButton(
                  child: Text(
                    "Have an Account? Sign In",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Get.to(LoginPage());
                  },
                )
              ],
            ))));
  }
}
