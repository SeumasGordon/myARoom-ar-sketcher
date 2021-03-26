import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:ui';

class FloorPlanModel {
  String id;
  String name;
  String notes;
  String imageURL;
  List<String> distanceString;
  List<Map<String, dynamic>> midPoints;
  List<Map<String, dynamic>> offsets;
  //Image from floor plan.

  FloorPlanModel(
      {this.id, this.name, this.offsets, this.midPoints, this.distanceString, this.notes, this.imageURL});

  FloorPlanModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    name = documentSnapshot.data()["name"];
    notes = documentSnapshot.data()["notes"];
    imageURL = documentSnapshot.data()["image"];
    offsets = List.castFrom(documentSnapshot.data()["offsets"] as List ?? []);
    distanceString =
        List.castFrom(documentSnapshot.data()["distanceString"] as List ?? []);
    midPoints =
        List.castFrom(documentSnapshot.data()["midpoints"] as List ?? []);
  }

  Offset mapToOffset(dynamic map) {
    return Offset(map["dx"], map["dy"]);
  }

  midPointsAsOffsets() {
    return midPoints.map((e) => this.mapToOffset(e)).toList();
  }

  offsetsAsOffsets() {
    return offsets.map((e) => this.mapToOffset(e)).toList();
  }
}
