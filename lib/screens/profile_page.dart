import 'package:ar_sketcher/controllers/authController.dart';
import 'package:ar_sketcher/controllers/userController.dart';
import 'package:ar_sketcher/screens/change_name.dart';
import 'package:ar_sketcher/screens/change_password.dart';
import 'package:ar_sketcher/screens/subscriptions_page.dart';
import 'package:ar_sketcher/services/database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePage extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Color(0xff1761a0))),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xff1761a0),
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(top: 40.0),
            alignment: Alignment.center,
            child: const Icon(Icons.account_circle_outlined,
                color: Color(0xff1761a0), size: 125),
          ),
          GetX<UserController>(
            initState: (_) async {
              Get.find<UserController>().user =
                  await Database().getUser(Get.find<AuthController>().user.uid);
            },
            builder: (_) {
              if (_.user.email != null) {
                return Text(
                  _.user.email,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                );
              } else {
                return Text("loading...");
              }
            },
          ),
          FlatButton(
            color: Color(0xff1761a0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            onPressed: () {
             Get.to(SubscriptionsPage());
            },
            child: Text(
              'Subscribe',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Card(
              margin: EdgeInsets.only(left: 15.0, top: 50.0, right: 15.0),
              elevation: 3.0,
              child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                      title: Text(
                        'Change Name',
                        textScaleFactor: 1.25,
                      ),
                      onTap: (){
                        Get.to(ChangeName());
                      },
                      trailing: Icon(Icons.arrow_forward, color: Colors.black)),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  ListTile(
                    title: Text(
                      'Change Password',
                      textScaleFactor: 1.25,
                    ),
                    trailing: Icon(Icons.arrow_forward, color: Colors.black),
                    onTap: () {
                      Get.to(ChangePassword());
                    },
                  )
                ],
              )),
          Card(
              margin: EdgeInsets.only(left: 15.0, top: 25.0, right: 15.0),
              elevation: 3,
              child: ListTile(
                  title: Text('Log out',
                      style: TextStyle(color: Colors.blue),
                      textScaleFactor: 1.25),
                  onTap: () {
                    controller.signOut();
                  })),
          Card(
              margin: EdgeInsets.only(left: 15.0, top: 25.0, right: 15.0),
              elevation: 3,
              child: ListTile(
                  title: Text('Delete Account',
                      style: TextStyle(color: Colors.red),
                      textScaleFactor: 1.25),
                  onTap: () async {
                    controller.deleteAccount();
                  }))
        ],
      ),
    );
  }
}
