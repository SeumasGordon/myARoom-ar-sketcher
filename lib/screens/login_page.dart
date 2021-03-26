import 'package:ar_sketcher/controllers/authController.dart';
import 'sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components_ui/rounded_btn.dart';
import '../components_ui/rounded_input.dart';
import '../components_ui/text_field_container.dart';



// ignore: must_be_immutable
class LoginPage extends GetWidget<AuthController> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Center(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo_icon.png', height: 150, width: 150,).paddingOnly(bottom: 20.0),
                RoundedInputField(
                  hintText: "Email",
                  icon: Icon(Icons.email, color: Color(0xff1761a0)),
                  keyboard: TextInputType.emailAddress,
                  controller: emailController,
                ),
                TextFieldContainer(
                  child: TextFormField(
                    obscureText: _obscureText,
                    cursorColor: Colors.black,
                    controller: passwordController,
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
                        },
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                RoundedButton(
                  color: Color(0xff1761a0),
                  textColor: Colors.white,
                  text: "LOGIN",
                  press: () {
                    controller.login(
                        emailController.text, passwordController.text);
                  },
                ),
                FlatButton(
                  child: Text(
                    "Create New Account",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Get.to(SignUpPage());
                  },
                )
              ],
            ))));
  }
}
