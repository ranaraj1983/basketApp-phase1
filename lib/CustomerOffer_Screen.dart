import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';

class CustomerOffer_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomerOffer_Screen();
}

class _CustomerOffer_Screen extends State<CustomerOffer_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser firebaseUser;

  @override
  void initState() {
    super.initState();
    Auth().getCurrentUser().then((user) {
      setState(() {
        firebaseUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      drawer: Navigation_Drawer(new Auth()),
      appBar: Custom_AppBar().getAppBar(context),
      bottomNavigationBar:
          Custom_AppBar().getBottomNavigation(context, firebaseUser),
      body: _getOfferPage(),
    );
  }

  Widget _getOfferPage() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 35),
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(35),
                borderSide: BorderSide.none,
              ),
              color: Colors.blue,
              child: Text(
                "Get A ScratchCard",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              onPressed: () => WidgetFactory().scratchCardDialog(context, 200),
            ),
          ),
        ],
      ),
    );
  }
}
