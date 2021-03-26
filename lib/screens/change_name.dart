import 'package:ar_sketcher/components_ui/rounded_btn.dart';
import 'package:ar_sketcher/components_ui/text_field_container.dart';
import 'package:ar_sketcher/controllers/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page.dart';

class ChangeName extends GetWidget<AuthController> {
  final TextEditingController nameController = TextEditingController();
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
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "Name",
                      icon: Icon(
                        Icons.person,
                        color: Color(0xff1761a0),
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
                    controller.changeName(nameController.text);
                    Get.to(HomePage());
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
            )));
  }
}
