// import 'dart:html';
import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ar_sketcher/models/floorplan.dart';
import 'package:ar_sketcher/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<String> distance = ["364.03", "404.87", "248.05", "483.11"];
  final List<Offset> offsets = [Offset(3.41,0.58),Offset(0.42, 0.58), Offset(0.42,4.98),Offset(3.41, 4.98)];
  final List<Offset> midP = [Offset(1.85,0.58),Offset(0.42, 3.06), Offset(1.98,4.98),Offset(3.41, 2.50)];
  Map<String, dynamic> offsetToMap(Offset offset) {
    return {'dx': offset.dx, 'dy': offset.dy};
  }

  Future<bool> createNewUser(UserModel userModel) async {
    try {
      await _firestore.collection("users").doc(userModel.id).set({
        "name": userModel.name,
        "email": userModel.email,
      });
      _firestore
          .collection("users")
          .doc(userModel.id)
          .collection("floorplans")
          .doc()
          .set({
        "name": "Example",
        "offsets": this.offsets.map((e) => this.offsetToMap(e)).toList(),
        "midpoints": this.midP.map((e)=> this.offsetToMap(e)).toList(),
        "distanceString": distance,
        "image": "https://firebasestorage.googleapis.com/v0/b/a-sketcher.appspot.com/o/floorplanImage%2FExample%2FARSketcher_20213921_37_44.png?alt=media&token=cfefcdc7-dca2-4d40-96a9-43f1d6b1c7ba",
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot _doc =
          await _firestore.collection("users").doc(uid).get();
      return UserModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> updateName(String uid, String name, String collection) async {
    _firestore.collection(collection).doc(uid).update({"name": name}).then((_) {
      print("success!");
    });
  }

  Future<void> updateMetric(String uid, bool isMetric, String collection) async {
    _firestore.collection(collection).doc(uid).update({"isMetric": isMetric}).then((_){
      print("success!");
    });
  }

  Future<void> updateFloorName(String uid, String name, String floorId) async {
    _firestore
        .collection("users")
        .doc(uid)
        .collection("floorplans")
        .doc(floorId)
        .update({"name": name}).then((_) {
      print("success!");
    });
  }

  Future<void> saveImages(File _image, String floorId, String uid) async {
    String imageURL = await uploadFile(_image, uid);
    await _firestore.collection("users").doc(uid).collection("floorplans").doc(floorId).update({"image": imageURL}).then((_){
      print("success");
    });
  }
  Future<String> uploadFile(File _image, String uid)async{
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('floorplanImage/${Path.basename(_image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    return await storageReference.getDownloadURL();
  }

  Future<void> saveNotes(String uid, String text, String floorId) async {
    _firestore
        .collection("users")
        .doc(uid)
        .collection("floorplans")
        .doc(floorId)
        .update({"notes": text}).then((_) {
      print("success!");
    });
  }

  Future<void> delete(String uid) {
    return _firestore.collection("users").doc(uid).delete();
  }

  Future<void> deleteFloorPlan(String uid, String floorId) {
    return _firestore
        .collection("users")
        .doc(uid)
        .collection("floorplans")
        .doc(floorId)
        .delete();
  }

  Future<DocumentReference> createFloorPlan(
      FloorPlanModel floorPlanModel, String uid) async {
    try {


      var docRef = await _firestore
          .collection("users")
          .doc(uid)
          .collection("floorplans")
          .add({
        "name": floorPlanModel.name,
        "offsets": floorPlanModel.offsets,
        "midpoints": floorPlanModel.midPoints,
        "distanceString": floorPlanModel.distanceString,
        "image": floorPlanModel.imageURL,
      });
      return docRef;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FloorPlanModel> getFloorPlan(String floorId, String uid) async {
    try {
      DocumentSnapshot _doc = await _firestore
          .collection("users")
          .doc(uid)
          .collection("floorplans")
          .doc(floorId)
          .get();
      return FloorPlanModel.fromDocumentSnapshot(documentSnapshot: _doc);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
