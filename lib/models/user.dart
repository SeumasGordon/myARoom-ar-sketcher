import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String id;
  String name;
  String email;
  //bool subscribed;
  bool isMetric;

  
  UserModel({this.id,this.name,this.email,this.isMetric});
  

  UserModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}){
    id = documentSnapshot.id;
    name = documentSnapshot.data()["name"];
    email = documentSnapshot.data()["email"];
    //subscribed = documentSnapshot.data()["subscribed"];
    isMetric = documentSnapshot.data()["isMetric"];
  }
}