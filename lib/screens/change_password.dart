import 'package:ar_sketcher/components_ui/rounded_btn.dart';
import 'package:ar_sketcher/components_ui/text_field_container.dart';
import 'package:ar_sketcher/controllers/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChangePassword extends GetWidget<AuthController>{
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmationController = TextEditingController();
  bool _obscureTextP = true;
  bool _obscureTextC = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.only(left: 33.0, right: 33.0, top: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFieldContainer(
                  child: TextFormField(
                    obscureText: _obscureTextP,
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      icon: Icon(
                        Icons.lock,
                        color: Color(0xff1761a0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextP
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xff1761a0),
                        ),
                        onPressed: () {
                          _obscureTextP = !_obscureTextP;
                          (context as Element).markNeedsBuild();
                        },
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextFieldContainer(
                  child: TextFormField(
                    obscureText: _obscureTextC,

                    controller: confirmationController,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      icon: Icon(
                        Icons.lock,
                        color: Color(0xff1761a0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureTextC
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color(0xff1761a0),
                        ),
                        onPressed: () {
                          _obscureTextC = !_obscureTextC;
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
                  text: "UPDATE",
                  press: () {
                    controller.changePassword(
                        passwordController.text, confirmationController.text);
                  },
                ),
                FlatButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ))
    );
  }

}