import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';

class CustomObject extends StatefulWidget {
  @override
  _CustomObjectState createState() => _CustomObjectState();
}

class _CustomObjectState extends State<CustomObject> {
  ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ArCoreView(onArCoreViewCreated: _onArCoreViewCreated),
        Container(
          child: Text(
            'Not implemented',
            style: TextStyle(fontSize: 30, color: Colors.red),
          ),
          margin: EdgeInsets.symmetric(vertical: 100.0, horizontal: 50.0),
        ) //UI
      ],
    ));
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    //arCoreController.onNodeTap = (name) => handleOnNodeTap(name);
    //arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  //void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {}
  void handleOnNodeTap(String name) {}
  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
