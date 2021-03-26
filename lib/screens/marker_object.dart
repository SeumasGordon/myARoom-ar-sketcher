import 'package:ar_sketcher/controllers/floorplanController.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'home_page.dart';
import 'floorplanView_page.dart'; //Will need for getting measurements from nodes.

class MarkerObject extends StatefulWidget {
  @override
  _MarkerObjectState createState() => _MarkerObjectState();
}

//vars used in floor_plan but made here
List<Offset> offsets = new List();
double minZSize = 0;
double minXSize = 0;
double maxZSize = 0;
double maxXSize = 0;

//for placing distance text at middle of line on canvas.
List<String> distanceString = new List();
List<Offset> midPoints = new List();

class _MarkerObjectState extends State<MarkerObject> {
  ArCoreController arCoreController;
  List<double> distances = new List();
  List<vector.Vector3> lastPoss = new List();
  List<vector.Vector3> middlePointsVector = new List();
  List<String> nodeNames = new List();

  List<String> disString = [];
  List<String> offsts = [];
  List<String> midpts = [];
  List<String> toList(List<Object> list, List<String> _toList) {
    list.forEach((element) {
      _toList.add(element.toString());
    });
    return _toList.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      ArCoreView(
        onArCoreViewCreated: _onArCoreViewCreated,
        enableTapRecognizer: true,
      ),
      Container(
          margin: EdgeInsets.only(left: 4, top: 35),
          child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                dispose();
                Get.off(HomePage());
              })),
      Container(
          margin: EdgeInsets.only(right: 4, top: 35),
          alignment: Alignment.topRight,
          child: IconButton(
              icon: Icon(Icons.replay_sharp, color: Colors.white, size: 30),
              onPressed: () {
                print('size ' +
                    (nodeNames.length).toString() +
                    ': lastpos ' +
                    (lastPoss.length).toString());
                print('undo all');
                int temp = nodeNames.length;
                for (int i = temp - 1; i >= 0; i--) {
                  arCoreController.removeNode(nodeName: nodeNames[i]);
                  String last = nodeNames.removeLast();
                  print('removed ' + last);
                }
                offsets = new List();
                lastPoss = new List();
                distanceString = new List();
                middlePointsVector = new List();
                print('size ' +
                    (nodeNames.length).toString() +
                    ': lastpos ' +
                    (lastPoss.length).toString());
              })),
      Container(
          margin: EdgeInsets.only(left: 45, bottom: 45),
          alignment: Alignment.bottomLeft,
          child: IconButton(
              icon: Icon(Icons.undo, color: Colors.white, size: 50),
              onPressed: () {
                print('Undo');
                int len = nodeNames.length;
                if (len == 0) {
                } else if (len == 1) {
                  arCoreController.removeNode(nodeName: nodeNames.last);
                  nodeNames.removeLast();
                  lastPoss.removeLast();
                } else {
                  for (int i = 1; i <= 2; i++) {
                    arCoreController.removeNode(nodeName: nodeNames[len - i]);
                    nodeNames.removeLast();
                  }
                  if (lastPoss.last == lastPoss[0]) {
                    lastPoss.removeLast();
                    distanceString.removeLast();
                    middlePointsVector.removeLast();
                    distances.removeLast();
                  }
                  distanceString.removeLast();
                  middlePointsVector.removeLast();
                  distances.removeLast();
                  lastPoss.removeLast();
                }
              })),
      Container(
          margin: EdgeInsets.only(bottom: 35),
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
              onTap: () => _addFinalLine(),
              onDoubleTap: () async {
                //Send info to floor_plan.dart
                //send distances to floor_plan.dart
                minZSize = 0;
                minXSize = 0;
                maxZSize = 0;
                maxXSize = 0;
                int possLen = lastPoss.length;
                for (int i = 0; i < possLen; i++) {
                  if (minXSize > lastPoss[i].x) {
                    minXSize = lastPoss[i].x;
                  }
                  if (minZSize > lastPoss[i].z) {
                    minZSize = lastPoss[i].z;
                  }

                  if (maxXSize < lastPoss[i].x) {
                    maxXSize = lastPoss[i].x;
                  }
                  if (maxZSize < lastPoss[i].z) {
                    maxZSize = lastPoss[i].z;
                  }
                }
                minZSize = minZSize.abs() + .1;
                minXSize = minXSize.abs() + .1;
                maxZSize += minZSize;
                maxXSize += minXSize;
                //converts the lastposs vector to offset.
                for (int j = 0; j < possLen; j++) {
                  offsets.add(Offset(
                      (lastPoss[j].x + minXSize), (lastPoss[j].z + minZSize)));
                  print(offsets[j]);
                }
                //auto align
                offsets.add(offsets[0]);
                double xtemp;
                double ytemp;
                for (int i = 0; i < offsets.length - 1; i++) {
                  xtemp = 0;
                  ytemp = 0;
                  xtemp = offsets[i].dx - offsets[i + 1].dx;
                  ytemp = offsets[i].dy - offsets[i + 1].dy;
                  if (xtemp.abs() > ytemp.abs()) {
                    double newy = 0;
                    newy = (offsets[i].dy + offsets[i + 1].dy) / 2;
                    offsets[i] = Offset(offsets[i].dx, newy);
                    offsets[i + 1] = Offset(offsets[i + 1].dx, newy);
                  } else if (ytemp.abs() > xtemp.abs()) {
                    double newx = 0;
                    newx = (offsets[i].dx + offsets[i + 1].dx) / 2;
                    offsets[i] = Offset(newx, offsets[i].dy);
                    offsets[i + 1] = Offset(newx, offsets[i + 1].dy);
                  }
                  if (i == 0) {
                    offsets.last = offsets[0];
                  }
                }
                offsets[0] = offsets.last; //still not functional
                offsets.removeLast();

                //adds the middle between the last position and the first position.
                if (lastPoss.length > 1) {
                  middlePointsVector
                      .add(_getMiddle(lastPoss.last, lastPoss[0]));
                  distanceString
                      .add(_calculateDistance(lastPoss.last, lastPoss[0]));
                }
                //converts the middle points to a offset with adjusting for canvas.
                for (int k = 0; k < middlePointsVector.length; k++) {
                  midPoints.add(Offset((middlePointsVector[k].x + minXSize),
                      (middlePointsVector[k].z + minZSize)));
                  print(midPoints[k]);
                }

                print('offsets length ' + offsets.length.toString());

                //not working as intented. TODO: make this rotate correctly
                /*if(maxXSize > maxZSize){
                  List<Offset> tempoffsets = new List();
                  for(int i = offsets.length-1; i >= 0; i--){
                    tempoffsets.add(Offset(offsets[i].dy,offsets[i].dx));
                  }
                  offsets = tempoffsets;
                }
                print('offsets length ' + offsets.length.toString());*/

                dispose();

                await Get.find<FloorPlanController>().createFloorPlan(
                    offsets, toList(distanceString, disString), midPoints);
                Get.find<FloorPlanController>().argument = "AR";
                Get.off(() => FloorPlan());
              },
              child: FloatingActionButton(
                child: Icon(Icons.check, color: Colors.white),
              )))
    ]));
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    offsets = new List();
    distanceString = new List();
    midPoints = new List();
    middlePointsVector = new List();
    arCoreController = controller;
    arCoreController.onNodeTap = (name) => handleOnNodeTap(name);
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  Future _addMarker(ArCoreHitTestResult hit) async {
    //
    final position = vector.Vector3.copy(hit.pose.translation);
    final markerMaterial = ArCoreMaterial(color: Colors.lightBlue);
    final markerSphere =
        ArCoreSphere(materials: [markerMaterial], radius: 0.03);

    final marker = ArCoreNode(
        shape: markerSphere, position: position, rotation: hit.pose.rotation);
    arCoreController.addArCoreNodeWithAnchor(marker);
    nodeNames.add(marker.name); //Doesn't add the the list.
    print('Added ' + marker.name + ' to list');
    if (lastPoss.length != 0) {
      vector.Vector3 size = vector.Vector3(.1, .1, .1);
      final lineMaterial = ArCoreMaterial(color: Colors.lightBlue);
      //final line = ArCoreCylinder(height: .01, radius: position.distanceTo(lastPos), materials: [lineMaterial]);
      final cube = ArCoreCube(materials: [lineMaterial], size: size);

      final distance = _calculateDistance(position, lastPoss.last);
      distanceString.add(distance);
      final middlePoint = _getMiddle(position, lastPoss.last);
      middlePointsVector.add(middlePoint);

      // final lineNode =
      //     ArCoreNode(shape: cube, position: middlePoint, name: distance);
      // arCoreController.addArCoreNodeWithAnchor(lineNode);
      // nodeNames.add(lineNode.name);
      // print('Added ' + lineNode.name + ' to list');
      drawLine(lastPoss.last, position, middlePoint, distance);
      //Add measurements to list to send to floorplanView_page.dart.
      distances.add(position.distanceTo(lastPoss.last));
    }
    lastPoss.add(position);
  }

  Future _addFinalLine() async {
    //
    final position = vector.Vector3.copy(lastPoss.last);

    vector.Vector3 size = vector.Vector3(.1, .1, .1);
    final lineMaterial = ArCoreMaterial(color: Colors.lightBlue);
    //final line = ArCoreCylinder(height: .01, radius: position.distanceTo(lastPos), materials: [lineMaterial]);
    final cube = ArCoreCube(materials: [lineMaterial], size: size);

    final distance = _calculateDistance(position, lastPoss[0]);
    distanceString.add(distance);
    final middlePoint = _getMiddle(position, lastPoss[0]);
    middlePointsVector.add(middlePoint);

    drawLine(lastPoss[0], position, middlePoint, distance);
    //Add measurements to list to send to floorplanView_page.dart.
  }

  //#region calculate distance
  String _calculateDistance(vector.Vector3 A, vector.Vector3 B) {
    //if(user.metric)
    return _calculateDistanceCM(A, B);
    //else
    //return _calculateDistanceIN(A, B);
  }

  //calculated distance between two ar vectors and returns measurements in CM
  String _calculateDistanceCM(vector.Vector3 A, vector.Vector3 B) {
    final length = A.distanceTo(B);
    return '${(length * 100).toStringAsFixed(2)}';
  }

  String _calculateDistanceIN(vector.Vector3 A, vector.Vector3 B) {
    final length = A.distanceTo(B);
    return '${(length * 39.3701).toStringAsFixed(2)}';
  }

  //#endregion

  vector.Quaternion LookAt(
      vector.Vector3 sourcePoint, vector.Vector3 destPoint) {
    //vector.Vector3 forwardVector = vector.Vector3.Normalize(destPoint - sourcePoint);
    final vector.Vector3 difference = vector.Vector3.copy(destPoint);
    difference.sub(sourcePoint);
    vector.Vector3 forwardVector = difference.normalized();

    var vecFwd = vector.Vector3(0, 0, 1);
    vector.Vector3 rotAxis = vector.Vector3.zero();
    vector.cross3(vecFwd, forwardVector, rotAxis);
    var dot = vector.dot3(vecFwd, forwardVector); //float

    vector.Quaternion q =
        vector.Quaternion(rotAxis.x, rotAxis.y, rotAxis.z, dot + 1);

    return q.normalized();
  }

  void drawLine(vector.Vector3 node1, vector.Vector3 node2, vector.Vector3 mid,
      String name) {
    //Draw a line between two AnchorNodes

    vector.Vector3 point1, point2;
    point1 = node1; //.getWorldPosition();
    point2 = node2; //.getWorldPosition();

    //First, find the vector extending between the two points and define a look rotation
    //in terms of this Vector.
    final vector.Vector3 difference = vector.Vector3.copy(point1);
    difference.sub(point2);
    final vector.Vector3 directionFromTopToBottom = difference.normalized();
    final vector.Quaternion rotationFromAToB = LookAt(point1, point2);
    //vector.Quaternion.fromTwoVectors(directionFromTopToBottom, vector.Vector3(0,1,0));
    //vector.Quaternion.fromTwoVectors(point1.normalized(), point2.normalized());

    vector.Vector4 rotation = vector.Vector4(rotationFromAToB.x,
        rotationFromAToB.y, rotationFromAToB.z, rotationFromAToB.w);
    ArCoreMaterial lineMaterial = ArCoreMaterial(color: Colors.blue);
    ArCoreCube cubeLine = ArCoreCube(
        materials: [lineMaterial],
        size: vector.Vector3(.01, .01, difference.length));

    var nodeForLine = new ArCoreNode(
        shape: cubeLine, position: mid, rotation: rotation, name: name);
    arCoreController.addArCoreNodeWithAnchor(nodeForLine);
    nodeNames.add(nodeForLine.name);
    print('Added ' + nodeForLine.name + ' to list');
  }
  // private void drawLine(AnchorNode node1, AnchorNode node2) {
  //   //Draw a line between two AnchorNodes
  //   Log.d(TAG,"drawLine");
  //   Vector3 point1, point2;
  //   point1 = node1.getWorldPosition();
  //   point2 = node2.getWorldPosition();
  //
  //
  //   //First, find the vector extending between the two points and define a look rotation
  //   //in terms of this Vector.
  //   final Vector3 difference = Vector3.subtract(point1, point2);
  //   final Vector3 directionFromTopToBottom = difference.normalized();
  //   final Quaternion rotationFromAToB =
  //   Quaternion.lookRotation(directionFromTopToBottom, Vector3.up());
  //   MaterialFactory.makeOpaqueWithColor(getApplicationContext(), new Color(0, 255, 244))
  //       .thenAccept(
  //       material -> {
  //   /* Then, create a rectangular prism, using ShapeFactory.makeCube() and use the difference vector
  //                                  to extend to the necessary length.  */
  //   Log.d(TAG,"drawLine insie .thenAccept");
  //   ModelRenderable model = ShapeFactory.makeCube(
  //   new Vector3(.01f, .01f, difference.length()),
  //   Vector3.zero(), material);
  //   /* Last, set the world rotation of the node to the rotation calculated earlier and set the world position to
  //                                  the midpoint between the given points . */
  //   Anchor lineAnchor = node2.getAnchor();
  //   nodeForLine = new Node();
  //   nodeForLine.setParent(node1);
  //   nodeForLine.setRenderable(model);
  //   nodeForLine.setWorldPosition(Vector3.add(point1, point2).scaled(.5f));
  //   nodeForLine.setWorldRotation(rotationFromAToB);
  //   }
  //   );
  //
  // }

  vector.Vector3 _getMiddle(vector.Vector3 A, vector.Vector3 B) {
    return vector.Vector3((A.x + B.x) / 2, (A.y + B.y) / 2, (A.z + B.z) / 2);
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    //Adds marker to a tap on plane on screen
    final hit = hits.first;
    //Make a hit counter that sets the hit.nodeName to a human readable name
    _addMarker(hit);
  }

  void handleOnNodeTap(String name) {
    //Gets the name of a Node that is tapped

    showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              content: Text('Node is named $name'),
            ));
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
