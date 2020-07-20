import 'dart:io';
import 'package:basketapp/Feedback_Screen.dart';
import 'package:basketapp/HomeScreen.dart';
import 'package:basketapp/admin/AdminConsole.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/help_screen.dart';
import 'package:basketapp/logind_signup.dart';
import 'package:basketapp/OderHistory_Screen.dart';
import 'package:basketapp/setting_screen.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:translator/translator.dart';

class Navigation_Drawer extends StatefulWidget {
  Navigation_Drawer(this.auth);

  final Auth auth;

  @override
  State<StatefulWidget> createState() => _Navigation_Drawer();
}

enum AuthStatus {
  noSignIn,
  SignIn,
}

class _Navigation_Drawer extends State<Navigation_Drawer> {
  AuthStatus authStatus = AuthStatus.noSignIn;
  FirebaseUser firebaseUser;
  File _image;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  String _currentAddress;

  @override
  void initState() {
    super.initState();

    widget.auth.getCurrentUser().then((userId) {
      setState(() async {
        authStatus = userId == null ? AuthStatus.noSignIn : AuthStatus.SignIn;
      });
    }).catchError((onError) {
      debugPrint(onError.toString());
    });

    WidgetFactory().getAddressFromLatLng().then((place) {
      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}";
      });
    });

    widget.auth.getCurrentUser().then((user) {
      setState(() {
        firebaseUser = user;
      });
    });
  }

  void _transletString(String input) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(input, to: 'bn');
    print(translation);
  }

  Widget _getUserProfile() {
    final input = "go mudi";
    _transletString(input);
    return UserAccountsDrawerHeader(
      accountName: Text(firebaseUser == null ? "" : firebaseUser.displayName),
      accountEmail: Text(firebaseUser == null ? "" : firebaseUser.email),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.yellowAccent,
        child: firebaseUser == null
            ? null
            : firebaseUser.providerData[1].providerId == "password"
                ? _image == null
                    ? WidgetFactory()
                        .getImageFromDatabase(context, firebaseUser.photoUrl)
                    : Image.file(
                        _image,
                        width: 150,
                        height: 150,
                      )
                : firebaseUser.providerData[1].providerId == "google.com"
                    ? WidgetFactory().getImageFromDatabaseByGoogle(
                        firebaseUser == null ? null : firebaseUser.photoUrl)
                    : Image.file(
                        _image,
                        width: 150,
                        height: 150,
                      ),

        /* WidgetFactory().getImageFromDatabase(
            context, firebaseUser == null ? null : firebaseUser.photoUrl),*/
      ),
      otherAccountsPictures: [
        CircleAvatar(
          backgroundColor: Colors.yellowAccent,
          backgroundImage: ExactAssetImage('images/logo.png'),
          child: Text(""),
        ),
      ],
    );
    /*return Card(

        child: UserAccountsDrawerHeader(
          accountName: new Text("${firebaseUser.displayName}"),
          accountEmail: new Text("${firebaseUser.email}"),
          decoration: new BoxDecoration(
            backgroundBlendMode: BlendMode.difference,
            color: Colors.indigo[700],
            shape: BoxShape.circle,
            *//*image: new DecorationImage(
                  image:new ExactAssetImage(
                      'images/goMudilogo.png'
                  ),
                  fit: BoxFit.contain,

                ),*//*
            gradient: new LinearGradient(
                colors: [Colors.yellowAccent, Colors.deepOrange],
                begin: Alignment.centerRight,
                end: new Alignment(-1.0, -1.0)),
            //boxShadow:
          ),
          *//*decoration: new BoxDecoration(
                      backgroundBlendMode: BlendMode.difference,
                      color: Colors.white30,
                      image: new DecorationImage(
                        image: new ExactAssetImage('assets/images/veg.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),*//*
          currentAccountPicture: Card(
            child: WidgetFactory()
                .getImageFromDatabase(context, firebaseUser.photoUrl),
          ),
    ));*/
  }

  Widget getSignInDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _getUserProfile(),
          //_getNavBarListWidget(name, Icons.favorite),
          Card(
            child: _currentAddress == null ? CircularProgressIndicator() : Row(
              children: [
                Icon(Icons.location_city),

                Text(_currentAddress),
              ],
            ),
          ),
          new Divider(),
          _getNavBarListWidget("Order History", Icons.history),
          new Divider(),
          _getNavBarListWidget("Settings", Icons.settings),
          //new Divider(),
          //_getNavBarListWidget("Dashboard", Icons.dashboard),
          new Divider(),
          _getNavBarListWidget("Help", Icons.help),
          new Divider(),
          _getNavBarListWidget("Logout", Icons.local_grocery_store),
          new Divider(),
          _getNavBarListWidget("Feedback", Icons.feedback),
          //new Divider(),
        ],
      ),
    );
  }

  Widget _getNavBarListWidget(String text, IconData ions) {
    return Card(

      child: new ListTile(
          leading: Icon(ions),
          title: new Text(
            text,
            style: new TextStyle(color: Colors.redAccent, fontSize: 17.0),
          ),
          onTap: () async {
            if (text == "Sign in") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Login_Screen()));
            } else if (text == "Settings") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Setting_Screen(
                        toolbarname: 'Setting',
                      )));
            } else if (text == "Help") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Help_Screen(
                        toolbarname: 'Help',
                      )));
            } else if (text == "Logout") {
              await Auth().signOut();
              setState(() {
                firebaseUser = null;
              });
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Home_screen()));
            } else if (text == "Dashboard") {} else if (text == "Admin") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminConsole()));
            } else if (text == "Feedback") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Feedback_Screen()));
            }
            else if (text == "Order History") {
              Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => OderHistory_Screen()));
            } else if (text == "") {} else if (text == "") {} else
            if (text == "") {} else if (text == "") {} else if (text == "") {}
          }
      ),
    );
  }

  Widget getLoggedOutDrawer() {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          _getHeaderWidget(),
          _getNavBarListWidget("Home", Icons.home),
          _getNavBarListWidget("Sign in", Icons.account_circle),
          _getNavBarListWidget("Settings", Icons.power_settings_new),
          _getNavBarListWidget("Help", Icons.help),
          //_getNavBarListWidget("Feedback", Icons.feedback),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.SignIn:
        return getSignInDrawer();
      case AuthStatus.noSignIn:
        return getLoggedOutDrawer();
    }
  }

  Widget _getHeaderWidget() {
    return Container(

    );
  }
}
