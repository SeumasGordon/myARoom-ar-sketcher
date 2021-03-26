import 'package:ar_sketcher/controllers/floorplanController.dart';
import 'package:ar_sketcher/screens/marker_object.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class DetailPage extends GetWidget<FloorPlanController> {
  final maxline = null;
  final notes = Get.find<FloorPlanController>().floorplanName.toString();
  final TextEditingController notesController = TextEditingController();

  // Gets the area of the floorplan
  String area(List<Offset> points){
    var n = points.length;
    double sum = 0.0;
    for(int i =0; i< n -1; ++i){
      sum += (points[i].dx * points[i + 1].dy) - (points[i + 1].dx * points[i].dy);
    }
    sum = (sum/2).abs();
    return (sum * 0.0264583333).toStringAsFixed(2); //0.0264583333 how many cm in a pixel
  }

  // Gets the perimeter of the floorplan
  String perimeter(List<String>sides){
    var perimeter = 0.0;
    for(int i =0; i < sides.length; ++i){
      perimeter += double.parse(sides[i]); // takes each string and parse it to a double
    }
    return perimeter.toStringAsFixed(0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details", style: TextStyle(color: Color(0xff1761a0))),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
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
        body: SingleChildScrollView(
          child: Column(children: [
            Card(
                margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                elevation: 3.0,
                child: ListView(shrinkWrap: true, children: [
                  ListTile(
                    title: Text(
                      'Ground Floor',
                      textScaleFactor: 1.25,
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 1.0, right: 1.0, top: 8.0, bottom: 16.0),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Surface\nPerimeter\n', //add \nVolume when we have 3D object
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          Column(
                            children: [
                              Text("${area(offsets)} cm2\n${perimeter(controller.floorplan.distanceString)} cm\n", // add volume value \n1624 ft3 when we have a 3D object
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.right),
                            ],
                            mainAxisAlignment: MainAxisAlignment.end,
                          ),
                          Column(
                            children: [
                              Text('Rooms\nDoors\nWindows',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.left),
                            ],
                            mainAxisAlignment: MainAxisAlignment.start,
                          ),
                          Column(
                            children: [
                              Text('1\n0\n0',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.right),
                            ],
                            mainAxisAlignment: MainAxisAlignment.end,
                          ),
                        ],
                      )
                    ]),
                  )
                ])),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            Visibility(visible: false, child:ListTile(
              title: Text(
                'MEASURES',
                textScaleFactor: 1.15,
                style: TextStyle(color: Colors.black38),
              ),
            ),),
            Visibility(visible: false,
              child:  Card(
              margin: EdgeInsets.only(left: 0, right: 0, top: 0),
              elevation: 3.0,
              child: ListTile(
                title: Text(
                  'Ceiling Height',
                  textScaleFactor: 1.25,
                  style: TextStyle(color: Colors.black),
                ),
                trailing: Text(
                  "8'",
                  textScaleFactor: 1.25,
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.end,
                ),
              ),
            ),),
            Padding(padding: EdgeInsets.only(top: 30.0)),
            ListTile(
              title: Text(
                'NOTES',
                textScaleFactor: 1.15,
                style: TextStyle(color: Colors.black38),
              ),
            ),
            Card(
                margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                elevation: 3.0,
                child: Container(
                  padding: EdgeInsets.only(bottom: 50.0),
                  child: Padding(padding:EdgeInsets.only(left:8.0, right: 8.0), child:TextField(

                    controller: notesController..text = controller.floorplanNotes.toString(),
                    onChanged: (String value)async{
                      controller.saveNotes(value);
                  },
                    // onChanged: controller.saveNotes(notesController.text),
                    keyboardType: TextInputType.multiline,
                    maxLines: maxline,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type something..."),
                  ),
                )))
          ]),
        ));
  }
}
