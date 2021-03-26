import 'package:ar_sketcher/models/user.dart';
import 'package:get/get.dart';

import 'package:ar_sketcher/services/database.dart';
import 'authController.dart';

class UserController extends GetxController{
  Rx<UserModel> _userModel = UserModel().obs;

  UserModel get user => _userModel.value;

  set user(UserModel value) => this._userModel.value = value;

  void changeMetric(bool isMetric){
    Database().updateMetric(Get.find<AuthController>().user.uid, isMetric, "users");
    _userModel.value.isMetric = isMetric;
    // _userModel.refresh();
  }

  void clear(){
    _userModel.value = UserModel();
  }
}