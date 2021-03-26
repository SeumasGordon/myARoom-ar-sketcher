import 'package:ar_sketcher/screens/home_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPage createState() => _HelpPage();
}

class _HelpPage extends State<HelpPage> {
  Widget fillChild(int position) {
    Widget value;
    switch (position) {
      case 1:
        {
          value = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Color(0xff1761a0),
                size: 150,
              ),
              Divider(
                height: 30,
                color: Colors.transparent,
              ),
              Text(
                'Access the AR camera to start creating floor plans.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              )
            ],
          );
        }
        break;
      case 2:
        {
          value = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.replay_sharp,
                color: Color(0xff1761a0),
                size: 150,
              ),
              Divider(
                height: 30,
                color: Colors.transparent,
              ),
              Text(
                'Restart your floor plan scan from zero deleting all changes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              )
            ],
          );
        }
        break;
      case 3:
        {
          value = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.undo,
                color: Color(0xff1761a0),
                size: 150,
              ),
              Divider(
                height: 30,
                color: Colors.transparent,
              ),
              Text(
                'Undo the most recent change on the floor plan scan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              )
            ],
          );
        }
        break;
      case 4:
        {
          value = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle_outlined,
                color: Color(0xff1761a0),
                size: 150,
              ),
              Divider(
                height: 30,
                color: Colors.transparent,
              ),
              Text(
                'you can always access your profile information and edit it from the home page by clicking the user icon.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              )
            ],
          );
        }
        break;
      case 5:
        {
          value = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home,
                color: Color(0xff1761a0),
                size: 150,
              ),
              Divider(
                height: 30,
                color: Colors.transparent,
              ),
              Text(
                'In the Home page you can always see all the current floor plans that are under your account.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              )
            ],
          );
        }
        break;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
          child: Center(
            child: CarouselSlider(
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: MediaQuery.of(context).size.height,
                  enlargeCenterPage: true),
              items: [1, 2, 3, 4, 5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: .1),
                        decoration: BoxDecoration(color: Colors.white),
                        child: fillChild(i));
                  },
                );
              }).toList(),
            ),
          )),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlatButton(
            color: Color(0xff1761a0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Text('Done', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
