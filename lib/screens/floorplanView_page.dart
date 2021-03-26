import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;
import 'dart:async';
import 'package:ar_sketcher/components_ui/rounded_btn.dart';
import 'package:ar_sketcher/components_ui/rounded_input.dart';
import 'package:ar_sketcher/controllers/floorplanController.dart';
import 'package:ar_sketcher/controllers/userController.dart';
import 'package:ar_sketcher/screens/detail_page.dart';
import 'package:ar_sketcher/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
//To get measurements to create floor plan.
import 'marker_object.dart';
import 'package:get/get.dart';
//import 'package:path_provider/path_provider.dart';

const directoryName = 'ARSketcher';

// ignore: must_be_immutable
class FloorPlan extends GetWidget<FloorPlanController> {
  final TextEditingController nameController = TextEditingController();
  var image;
  var _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Future<bool> _onBackPressed() {
      return Get.dialog(
            AlertDialog(
              title: new Text('Warning'),
              content: new Text('Do you want to go back?'),
              actions: <Widget>[
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Get.find<FloorPlanController>().clear();
                          Navigator.of(context).pop(true);
                          Get.off(HomePage());
                        },
                        child: Text('Yes')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No'))
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 25),
              child: FlatButton(
                  color: Color(0xff1761a0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0)),
                  onPressed: () async {
                    if (controller.argument == "AR") {
                      //await setRenderedImage(context);
                      RenderRepaintBoundary boundary =
                          _globalKey.currentContext.findRenderObject();
                      var image = await boundary.toImage(pixelRatio: 3.0);
                      await saveImage(image);
                    }
                    controller.argument = "";

                    //Add function
                    Get.dialog(AlertDialog(
                        title: Text('Warning'),
                        actions: [
                          Row(
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.find<FloorPlanController>().clear();
                                    Get.off(HomePage());
                                  },
                                  child: Text('OK')),
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('CANCEL'))
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                        ],
                        content: SingleChildScrollView(
                            child: ListBody(
                          children: [
                            Text(
                                'You are about to leave the project. All changes will be save.')
                          ],
                        ))));
                  },
                  child: Text(
                    'Exit',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: Container(
                  //color: Colors.black,
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: LayoutBuilder(
                      builder: (_, constraints) => Container(
                            width: constraints.widthConstraints().maxWidth,
                            height: constraints.heightConstraints().maxHeight,
                            color: Colors.white,
                            child: /*Center(child:Column(children: [*/
                                RepaintBoundary(
                              key: _globalKey,
                              child: CustomPaint(painter: BluePrintPainter()),
                            ),
                          ))),
            ),
          ]),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(
                  right: 10.0, left: 10.0, bottom: 25.0, top: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                height: 115,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MaterialButton(
                            onPressed: () {
                              Get.dialog(SimpleDialog(
                                children: [
                                  RoundedInputField(
                                          controller: nameController,
                                          hintText: "name")
                                      .paddingOnly(
                                          left: 20.0, right: 20.0, top: 10.0),
                                  RoundedButton(
                                    color: Color(0xff1761a0),
                                    textColor: Colors.white,
                                    text: "OK",
                                    press: () {
                                      controller.changeFloorName(
                                          nameController.text,
                                          controller.floorplan.id);
                                      Navigator.of(context).pop();
                                    },
                                  ).paddingOnly(
                                      left: 20.0, right: 20.0, bottom: 10.0)
                                ],
                              ));
                            },
                            child: Obx(() => Text(
                                  controller.floorplanName == null
                                      ? "name"
                                      : controller.floorplanName.toString(),
                                  style: TextStyle(color: Colors.black),
                                ))),
                        TextButton(
                            onPressed: () {
                              Get.to(() => DetailPage());
                            },
                            child: Text(
                              'details',
                              style: TextStyle(color: Color(0xff1761a0)),
                            ))
                      ],
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                    ),
                    Row(
                      //TODO: By clicking any of the options clears the canvas !!!!!!
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 40.0),
                                child: Column(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Color(0xff1761a0),
                                      ),
                                      onPressed: () {
                                        //Add function
                                      },
                                    ),
                                    Text('Add Object',
                                        style:
                                            TextStyle(color: Color(0xff1761a0)))
                                  ],
                                )),
                          ],
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon:
                                  Icon(Icons.block_flipped, color: Colors.red),
                              onPressed: () {
                                //Add function
                                Get.dialog(AlertDialog(
                                    title: Text('Warning'),
                                    actions: [
                                      Row(
                                        children: [
                                          TextButton(
                                              onPressed: () {
                                                //add functionality
                                              },
                                              child: Text('OK')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('CANCEL'))
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                      ),
                                    ],
                                    content: SingleChildScrollView(
                                        child: ListBody(
                                      children: [
                                        Text(
                                            'All changes will be delete it.\nWould you like to proceed?')
                                      ],
                                    ))));
                              },
                            ),
                            Text('Cancel', style: TextStyle(color: Colors.red))
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 55.0),
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.undo,
                                        color: Color(0xff1761a0)),
                                    onPressed: () {
                                      //Add function
                                      Get.dialog(AlertDialog(
                                          title: Text('Warning'),
                                          actions: [
                                            Row(
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      //add functionality
                                                    },
                                                    child: Text('OK')),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('CANCEL'))
                                              ],
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                            ),
                                          ],
                                          content: SingleChildScrollView(
                                              child: ListBody(
                                            children: [
                                              Text(
                                                  'Last change will be delete it.\nWould you like to proceed?')
                                            ],
                                          ))));
                                    },
                                  ),
                                  Text('Undo',
                                      style:
                                          TextStyle(color: Color(0xff1761a0)))
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ))),
    );
    // default:
    //   return Text("default");
  }
  // });
  // }

  // setRenderedImage(BuildContext context) async {
  //
  //   print('setRederedImage Starts');
  //   ui.PictureRecorder recorder = ui.PictureRecorder();
  //   Canvas canvas = Canvas(recorder);
  //   BluePrintPainter painter = BluePrintPainter();
  //   var size = Get.size;//context.size;
  //   print(size);
  //   painter.paint(canvas, size);
  //   final picture = recorder.endRecording();
  //   ui.Image renderedImage =
  //       await picture.toImage(size.width.floor(), size.height.floor());
  //   //setState(() {
  //   image = renderedImage;
  //   //});
  //   print('setRederedImage Ends');
  //   await saveImage(image);
  // }
  //
  Future<Null> saveImage(ui.Image image) async {
    print('saveImage Called');

    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);

    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;
    print(path);
    await Directory('$path/$directoryName').create(recursive: true);
    var file = File('$path/$directoryName/${imageName()}.png');
    file.writeAsBytesSync(pngBytes.buffer.asInt8List());
    controller.saveImage(file, controller.floorplan.id);
  }

  String imageName() {
    DateTime dateTime = DateTime.now();
    String imgName = 'ARSketcher_' +
        dateTime.year.toString() +
        dateTime.month.toString() +
        dateTime.day.toString() +
        dateTime.hour.toString() +
        ':' +
        dateTime.minute.toString() +
        ':' +
        dateTime.second.toString();
    return imgName;
  }
}

class BluePrintPainter extends CustomPainter {
  String name;
  BluePrintPainter({this.name});
  String unit = "cm";

  Offset centroid(List<Offset> points, double scaler) {
    List<double> centroid = [0, 0];

    for (int i = 0; i < points.length; i++) {
      centroid[0] += points[i].dx;
      centroid[1] += points[i].dy;
    }

    int totalPoints = points.length;
    centroid[0] = centroid[0] / totalPoints;
    centroid[1] = centroid[1] / totalPoints;

    return Offset(centroid[0] * scaler, centroid[1] * scaler);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.black;

    final dotPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = Colors.blue;

    final style = TextStyle(
        color: ThemeData.light().accentColor,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.normal,
        fontSize: 20.0);

    if (Get.arguments == "HomePage") {
      offsets = Get.find<FloorPlanController>().floorplan.offsetsAsOffsets();
      distanceString = Get.find<FloorPlanController>().floorplan.distanceString;
      midPoints =
          Get.find<FloorPlanController>().floorplan.midPointsAsOffsets();
    }
    if(!Get.find<UserController>().user.isMetric){
      distanceString = cmToIn(distanceString);
      unit = 'in';
    }

    int leng = offsets?.length;
    //check if max or min are past edge with scaler if so scaler -1 and retry.
    double scaler = 75;
    if (maxXSize * 5 > size.width || maxZSize * 5 > size.height) {
      //if the size at min is to big it kicks your out.
      print('ERROR: BluePrint to big.');
      Get.to(MarkerObject());
    }
    while (maxXSize * scaler > size.width || maxZSize * scaler > size.height) {
      //could split into two loops if problems occur.
      scaler -= 5.0;
    }

    double tempdx = 0;
    double tempdy = 0;
    var centerPoint = centroid(offsets, scaler);
    for (int i = 0; i < leng; i++) {
      print(scaler);
      tempdx = offsets[i].dx * scaler;
      tempdy = offsets[i].dy * scaler;
      offsets[i] = Offset(tempdx + center.dx - centerPoint.dx,
          tempdy + center.dy - centerPoint.dy);
    }

    for (int i = 0; i < midPoints.length; i++) {
      tempdx = midPoints[i].dx * scaler;
      tempdy = midPoints[i].dy * scaler;
      midPoints[i] = Offset(tempdx + center.dx - centerPoint.dx,
          tempdy + center.dy - centerPoint.dy);
    }

    //lastPoss
    if (leng > 1) {
      for (int i = 1; i < leng; i++) {
        canvas.drawLine(offsets[i - 1], offsets[i], paint);
      }
      canvas.drawLine(offsets[leng - 1], offsets[0], paint);
    }

    //text painter
    for (int i = 0; i < midPoints.length; i++) {
      final TextPainter textPainter = TextPainter(
          text: TextSpan(text: distanceString[i] + unit, style: style),
          textAlign: TextAlign.justify,
          textDirection: TextDirection.ltr)
        ..layout(maxWidth: size.width - 20);
      textPainter.paint(canvas, midPoints[i]);
    }

    canvas.drawPoints(PointMode.points, offsets, dotPaint);

    //save canvas to a temp area and on save it edits file name and stuff for database collection.
    //canvas.save();
  }

  List<String> cmToIn(List<String> list){
    double temp = 0;
    List<String> newList = new List();
    for(int i = 0; i < list.length; i++){
      temp = double.parse(list[i]);
      temp = temp*.3937;
      newList.add(temp.toStringAsFixed(2));
    }
    return newList;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelate) => true;

  @override
  bool shouldRebuildSemantics(covariant CustomPainter oldDelegate) => true;
}
