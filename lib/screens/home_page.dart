import 'package:ar_sketcher/components_ui/floor_plan_card.dart';
import 'package:ar_sketcher/controllers/authController.dart';
import 'package:ar_sketcher/controllers/floorplanController.dart';
import 'package:ar_sketcher/controllers/userController.dart';
import 'package:ar_sketcher/screens/marker_object.dart';
import 'package:ar_sketcher/screens/selection_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'floorplanView_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'package:ar_sketcher/screens/subscriptions_page.dart';
import 'package:ar_sketcher/services/database.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetWidget<AuthController> {
  final TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Center(
            child: GetX<UserController>(
          initState: (_) async {
            Get.find<UserController>().user =
                await Database().getUser(Get.find<AuthController>().user.uid);
          },
          builder: (_) {
            if (_.user.name != null) {
              return Text(
                _.user.name,
                style: TextStyle(color: Color(0xff1761a0)),
              );
            } else {
              return Text("loading...");
            }
          },
        )),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xff1761a0)),
        actions: [
          IconButton(
              icon: const Icon(Icons.account_circle_outlined,
                  color: Color(0xff1761a0), size: 30),
              onPressed: () {
                Get.to(ProfilePage());
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.only(top: 60, left: 20),
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.assignment_ind,
                  size: 30,
                  color: Color(0xff1761a0),
                ),
                title: Text(
                  'Profile',
                  style: TextStyle(fontSize: 20, color: Color(0xff1761a0)),
                ),
                onTap: () {
                  Get.to(ProfilePage());
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.settings,
                  size: 30,
                  color: Color(0xff1761a0),
                ),
                title: Text(
                  'Settings',
                  style: TextStyle(fontSize: 20, color: Color(0xff1761a0)),
                ),
                onTap: () {
                  Get.to(SettingsPage());
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.assistant_outlined,
                  size: 30,
                  color: Color(0xff1761a0),
                ),
                title: Text(
                  'Subscriptions',
                  style: TextStyle(fontSize: 20, color: Color(0xff1761a0)),
                ),
                onTap: () {
                  Get.to(SubscriptionsPage());
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  size: 30,
                  color: Color(0xff1761a0),
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: Color(0xff1761a0)),
                ),
                onTap: () {
                  controller.signOut();
                },
              )
            ]),
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            new Container(
              padding: const EdgeInsets.only(left: 33.0, right: 33.0, top: 8.0),
              child: TextField(
                onChanged: (value) {},
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(controller.user.uid)
                  .collection("floorplans")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return new Text('${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Center(child: new CircularProgressIndicator());
                  case ConnectionState.active:
                    return GridView.builder(
                        physics: ScrollPhysics(),
                        primary: true,
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PlanCard(
                            name: snapshot.data.docs[index]["name"],
                            id: snapshot.data.docs[index].id,
                            image: snapshot.data.docs[index]["image"] == null
                                ? Image.asset(
                                    'assets/logo_icon.png',
                                    height: 75,
                                    width: 75,
                                    alignment: Alignment.topCenter,
                                  )
                                : Image.network(
                                    snapshot.data.docs[index]["image"],
                                    height: 75,
                                    width: 75,
                                    alignment: Alignment.topCenter,
                                  ),
                            onPress: () async {
                              await Get.find<FloorPlanController>()
                                  .getFloorPlan(snapshot.data.docs[index].id);

                              Get.to(() => FloorPlan(), arguments: "HomePage");
                            },
                          );
                        });
                  default:
                    return Text("default");
                }
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        height: 60,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff1761a0),
        child: new Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          //Get.to(() => SelectionPage()); // for when we have objects implemented
          Get.to(() => MarkerObject());
        },
      ),
    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}
