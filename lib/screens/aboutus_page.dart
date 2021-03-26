import 'package:ar_sketcher/controllers/authController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About Us", style: TextStyle(color: Color(0xff1761a0))),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xff1761a0)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 25.0, left: 16.0, right: 16.0),
          child: Column(
            children: [
              Text(
                  'We are a small team of developers working on our final project. This application still on development and we always appreciate the feedback.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18)),
              Padding(
                padding: EdgeInsets.only(top: 80),
              ),
              Text('Contact Us',
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                  textAlign: TextAlign.left),
              Padding(
                padding: EdgeInsets.only(top: 25.0),
              ),
              Text('Email:',
                  style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              TextButton(
                  onPressed: () async =>
                      {await launch("mailto:lsandsgproject@gmail.com")},
                  child: Text('lsandsgproject@gmail.com',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          decoration: TextDecoration.underline)))
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ));
  }
}
