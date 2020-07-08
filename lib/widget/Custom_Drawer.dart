import 'dart:async';

import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/help_screen.dart';
import 'package:basketapp/logind_signup.dart';
import 'package:basketapp/OderHistory_Screen.dart';
import 'package:basketapp/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Custom_Drawer {
  String photoUrl;
  String uid;
  String dispalyName;
  String phoneNumber;
  String email;

  Future<String> checkLoginUser() async {
    //String userId =  Auth().getCurrentUserId() ;

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    new Timer(new Duration(milliseconds: 5), () {
      photoUrl = user.photoUrl;
      uid = user.uid;
      phoneNumber = user.phoneNumber;
      dispalyName = user.displayName;
      email = user.email;
    });

    return null;
  }


  Widget getDrawer(BuildContext context) {
    String name = "Custom Drawer";
    Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();
    return Drawer(
      child: new ListView(
        children: <Widget>[
          new Card(
            child: UserAccountsDrawerHeader(
              accountName: new Text("${user}"),
              accountEmail: new Text("NaomiASchultz@armyspy.com"),
              onDetailsPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        //builder: (context) => Account_Screen()
                        ));
              },
              decoration: new BoxDecoration(
                backgroundBlendMode: BlendMode.difference,
                color: Colors.white30,
                image: new DecorationImage(
                  image: new ExactAssetImage('assets/images/veg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://www.fakenamegenerator.com/images/sil-female.png")),
            ),
          ),
          new Card(
            elevation: 4.0,
            child: new Column(
              children: <Widget>[
                new ListTile(
                    leading: Icon(Icons.favorite),
                    title: new Text(name),
                    onTap: () {
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=> Item_Screen(toolbarname: name,)));
                    }),
                new Divider(),
                new ListTile(
                    leading: Icon(Icons.history),
                    title: new Text("Order History "),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OderHistory_Screen(
                                    toolbarname: ' Order History',
                                  )));
                    }),
              ],
            ),
          ),
          new Card(
            elevation: 4.0,
            child: new Column(
              children: <Widget>[
                new ListTile(
                    leading: Icon(Icons.settings),
                    title: new Text("Setting"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Setting_Screen(
                                toolbarname: 'Setting',
                              )));
                    }),
                new Divider(),
                new ListTile(
                    leading: Icon(Icons.help),
                    title: new Text("Help"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Help_Screen(
                                toolbarname: 'Help',
                              )));
                    }),
              ],
            ),
          ),
          new Card(
            elevation: 4.0,
            child: new ListTile(
                leading: Icon(Icons.power_settings_new),
                title: new Text(
                  "Logout",
                  style: new TextStyle(color: Colors.redAccent, fontSize: 17.0),
                ),
                onTap: () {
                  Auth().signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login_Screen()));
                }),
          )
        ],
      ),
    );
  }
}
