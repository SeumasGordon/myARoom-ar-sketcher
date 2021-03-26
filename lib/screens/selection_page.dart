import 'package:ar_sketcher/controllers/authController.dart';
import 'package:ar_sketcher/screens/marker_object.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectionPage extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Type", style: TextStyle(color: Color(0xff1761a0))),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xff1761a0),),onPressed: (){
          Get.back();
        },),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.only(left: 15.0, top: 25.0, right: 15.0),
          elevation: 3,
          child: ListTile(
              title: Text('Room',
                  style: TextStyle(color: Color(0xff1761a0)),
                  textScaleFactor: 1.25),
              onTap: () {

                Get.to(MarkerObject());
              })),
        Card(
            margin: EdgeInsets.only(left: 15.0, top: 25.0, right: 15.0),
            elevation: 3,
            child: ListTile(
                title: Text('Object',
                    style: TextStyle(color: Color(0xff1761a0)),
                    textScaleFactor: 1.25),
                onTap: () {
                  Get.to(MarkerObject());
                })),
    ],));
  }
}
