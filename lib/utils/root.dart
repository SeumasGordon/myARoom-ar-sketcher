import 'package:ar_sketcher/controllers/authController.dart';
import 'package:ar_sketcher/controllers/floorplanController.dart';
import 'package:ar_sketcher/controllers/userController.dart';
import 'package:ar_sketcher/screens/login_page.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../screens/home_page.dart';

class Root extends GetWidget<AuthController>{
  @override
  Widget build(BuildContext context){
    return GetX(
      initState: (_) async {
        Get.put<UserController>(UserController());
        Get.put<FloorPlanController>(FloorPlanController());
      },
      builder: (_) {
        if(Get.find<AuthController>().user?.uid != null){
          return HomePage();
        }else{
          return LoginPage();
        }
      },
    );
  }
}