

import 'package:ar_sketcher/controllers/userController.dart';

import 'package:ar_sketcher/models/user.dart';
import 'package:ar_sketcher/screens/help_page.dart';
import 'package:ar_sketcher/screens/login_page.dart';
import 'package:ar_sketcher/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../screens/home_page.dart';


class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Rx<User> _firebaseUser = Rx<User>();

  User get user => _firebaseUser.value;

  @override
  // ignore: must_call_super
  void onInit() {
    _firebaseUser.bindStream(_auth.authStateChanges());
  }

  void createUser(String name, String email, String password) async {
    try {
      if (name.isEmpty) {
        Get.snackbar("Error creating account", "One or more fields are empty",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        UserCredential _authResult = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password);
        UserModel _user = UserModel(
          id: _authResult.user.uid,
          name: name,
          email: _authResult.user.email,
        );
        if (await Database().createNewUser(_user)) {
          Get.find<UserController>().user = _user;
          Get.to(HelpPage());
        }
      }
    } catch (e) {
      if (e.message == "Given String is empty or null") {
        Get.snackbar("Error creating account", "One or more fields are empty",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error creating account.", e.message,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void login(String email, String password) async {
    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      Get.find<UserController>().user =
          await Database().getUser(_authResult.user.uid);
      Get.to(HomePage());
    } catch (e) {
      if (e.message == "Given String is empty or null") {
        Get.snackbar(
            "Error login in the account.", "One or more fields are empty",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error login in the account.", e.message,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      Get.find<UserController>().clear();
      Get.to(LoginPage());
    } catch (e) {
      Get.snackbar("Error login out.", e.message,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void changePassword(String password, String confirmation) async {
    try {
      if (password == confirmation) {
        await _auth.currentUser.updatePassword(password);
        Get.back();
      } else {
        Get.snackbar("Error", "Passwords do not match.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", e.message, snackPosition: SnackPosition.BOTTOM);
    }
  }

  void changeName(String name) async {
    Database().updateName(Get.find<AuthController>().user.uid, name, "users");
  }

  void deleteAccount() async {
    try {
      Database().delete(Get.find<AuthController>().user.uid);
      await _auth.currentUser.delete();
      Get.find<UserController>().clear();
      Get.to(LoginPage());
    } catch (e) {
      print(e);
    }
  }
}
