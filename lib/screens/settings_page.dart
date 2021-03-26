import 'package:ar_sketcher/controllers/authController.dart';
import 'package:ar_sketcher/controllers/userController.dart';
import 'package:ar_sketcher/screens/aboutus_page.dart';
import 'package:ar_sketcher/screens/help_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsPage extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings", style: TextStyle(color: Color(0xff1761a0))),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xff1761a0)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.only(top: 30, left: 8, right: 8),
              elevation: 3.0,
              child: ListTile(
                title: Text(
                  'Units',
                  textScaleFactor: 1.25,
                  style: TextStyle(color: Colors.black),
                ),
                trailing: ToggleSwitch(
                  initialLabelIndex: Get.find<UserController>().user.isMetric == true?1:0,
                  labels: ['in', 'cm'],
                  inactiveBgColor: Colors.white,
                  onToggle: (index){
                    Get.find<UserController>().changeMetric(index == 0?false: true);
                  },
                ),
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 8, right: 8, top: 15),
              elevation: 3.0,
              child: ListTile(
                title: Text(
                  'Help',
                  textScaleFactor: 1.25,
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Get.to(HelpPage());
                },
              ),
            ),
            Card(
              margin: EdgeInsets.only(left: 8, right: 8, top: 15),
              elevation: 3.0,
              child: ListTile(
                  title: Text(
                    'About Us',
                    textScaleFactor: 1.25,
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Get.to(AboutUsPage());
                  }),
            ),
          ],
        ));
  }
}
