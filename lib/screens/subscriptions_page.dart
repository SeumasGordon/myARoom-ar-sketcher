import 'package:ar_sketcher/controllers/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// class SubscriptionsPage extends StatefulWidget {
//   // ProfilePage({Key key, this.title}) : super(key: key);
//   //
//   // String title = "Profile";
//
//   @override
//   _SubscriptionsPageState createState() => _SubscriptionsPageState();
// }

class SubscriptionsPage extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscriptions", style: TextStyle(color: Color(0xff1761a0))),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xff1761a0)),onPressed: (){
          Get.back();
        },),
      ),
    );
  }
}