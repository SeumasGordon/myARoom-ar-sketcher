import 'package:ar_sketcher/controllers/authController.dart';

import 'package:ar_sketcher/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum options {
  delete,
}

class PlanCard extends StatelessWidget {
  final String name;
  final String id;
  final Function onPress;
  final Color color, textColor;
  final Image image;

  const PlanCard(
      {Key key, this.name, this.onPress, this.color, this.textColor, this.id, this.image})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
            onTap: onPress,
            child: Column(
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                  visualDensity: VisualDensity(vertical: -4),
                  trailing: PopupMenuButton<options>(
                    onSelected: (options result) {
                      Database().deleteFloorPlan(
                          Get.find<AuthController>().user.uid, id);
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<options>>[
                      const PopupMenuItem<options>(
                          value: options.delete, child: Text("Delete"))
                    ],
                  ),
                ),
                image,
                ButtonBar(alignment: MainAxisAlignment.center, children: [
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  )
                ]),
              ],
            )));
  }
}
