import 'package:ar_sketcher/binding/authBinding.dart';
import 'package:ar_sketcher/utils/root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //debugRepaintRainbowEnabled = true;
  //debugProfilePaintsEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Sketcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Main Color
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialBinding: AuthBinding(),
      home: Root(),
    );
  }
}

