import 'dart:ui';
import 'dart:io';
import 'package:ar_sketcher/controllers/authController.dart';
import 'package:ar_sketcher/services/database.dart';
import 'package:get/get.dart';
import 'package:ar_sketcher/models/floorplan.dart';

class FloorPlanController extends GetxController {
  Rx<FloorPlanModel> _floorplan = FloorPlanModel().obs;

  FloorPlanModel get floorplan => _floorplan.value;
  RxString get floorplanName => _floorplan.value.name.obs;
  RxString get floorplanNotes => _floorplan.value.notes.obs;
  String  argument;

  set floorplan(FloorPlanModel value) => this._floorplan.value = value;

  Future<void> getFloorPlan(String floorId) async {
    _floorplan.value = await Database()
        .getFloorPlan(floorId, Get.find<AuthController>().user.uid);
  }

  Future<void> createFloorPlan(List<Offset> _offsets, List<String> _distanceStrings,
      List<Offset> _midPoints) async {
    try {
      FloorPlanModel _floorplan = FloorPlanModel(
          name: "name",
          midPoints: _midPoints.map((e) => this.offsetToMap(e)).toList(),
          distanceString: _distanceStrings,
          offsets: _offsets.map((e) => this.offsetToMap(e)).toList());
      var z = await Database()
          .createFloorPlan(_floorplan, Get.find<AuthController>().user.uid);
      if (z != null) {

        floorplan = _floorplan;
        floorplan.id = z.id;
      }

    } catch (e) {}

  }

  void changeFloorName(String name, String floorId) async {
    Database()
        .updateFloorName(Get.find<AuthController>().user.uid, name, floorId);
    _floorplan.value.name = name;
    _floorplan.refresh();
  }

  void saveNotes(String text) async {
    await Database().saveNotes(Get.find<AuthController>().user.uid, text, Get.find<FloorPlanController>().floorplan.id);
    _floorplan.value.notes = text;
    _floorplan.refresh();
  }

  void saveImage(File _image, String floorId){
    Database().saveImages(_image, floorId, Get.find<AuthController>().user.uid);
  }

  Map<String, dynamic> offsetToMap(Offset offset) {
    return {'dx': offset.dx, 'dy': offset.dy};
  }

  void clear() {
    _floorplan.value = FloorPlanModel();
  }
}
