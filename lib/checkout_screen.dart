import 'package:basketapp/Payment_Screen.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Custom_Drawer.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class Checkout extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CheckOut_Screen();
}


class _CheckOut_Screen extends State<Checkout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  final formKey = GlobalKey<FormState>();

  IconData _backIcon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.arrow_back;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  int totalPrice = 0;

  FirebaseUser firebaseUser;

  @override
  void initState() {
    super.initState();
    Auth().getCurrentUser().then((value) {
      setState(() {
        value != null ? firebaseUser = value : firebaseUser = null;
      });
    });
    setState(() {
      totalPrice = Custom_AppBar().getCartTotalPrice();
    });
    //prepareDirPath();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      drawer: Navigation_Drawer(new Auth()),
      appBar: Custom_AppBar().getAppBar(context),
      bottomNavigationBar:
          Custom_AppBar().getBottomNavigation(context, firebaseUser),
      body: _getCheckOutBodyWidget(),
    );
  }

  Widget _getCheckOutBodyWidget() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin:
                EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
            child: new Text(
              'Delivery Address',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
          Container(
            width: width,
            color: Colors.white10,
            child: firebaseUser == null
                ? Text("")
                : WidgetFactory().getCustomerAddress(context, formKey),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin:
                EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
            child: Text(
              'Order Summary',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
          SizedBox(
            //height: height,
            width: width,
            child: Observer(
              builder: (_) =>
                  Stack(
                    children: [
                      Custom_AppBar().getCartListWidgetListView(context),

                    ],
                  ),

            ),
          ),


        ],
      ),
    );
  }

  IconData _add_icon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.add;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  IconData _sub_icon() {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return Icons.remove;
      case TargetPlatform.iOS:
        return Icons.arrow_back_ios;
    }
    assert(false);
    return null;
  }

  _verticalDivider() => Container(
    padding: EdgeInsets.all(2.0),
  );

  _verticalD() => Container(
    margin: EdgeInsets.only(left: 3.0, right: 0.0, top: 0.0, bottom: 0.0),
  );
}
