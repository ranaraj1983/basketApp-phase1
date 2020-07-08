import 'dart:async';

import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/item_details.dart';
import 'package:basketapp/item_screen.dart';
import 'package:basketapp/OderHistory_Screen.dart';
import 'package:basketapp/services/Order_Service.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Payment_Screen extends StatefulWidget {
  int totalPrice;

  Payment_Screen(this.totalPrice);

  @override
  State<StatefulWidget> createState() => _Paymet_Screen(totalPrice);
}

class _Paymet_Screen extends State<Payment_Screen> {
  int totalPrice;

  _Paymet_Screen(this.totalPrice);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool checkboxValueA = true;
  bool checkboxValueB = false;
  bool checkboxValueC = false;

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

  int radioValue = 0;

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  String toolbarname = 'CheckOut';


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final double height = MediaQuery.of(context).size.height;


    return new Scaffold(
      key: _scaffoldKey,
      drawer: Navigation_Drawer(new Auth()),
      bottomNavigationBar: Custom_AppBar().getButtomNavigation(
          context, firebaseUser),
      appBar: Custom_AppBar().getAppBar(context),
      body: new Column(
        children: <Widget>[
          /*Container(
              margin: EdgeInsets.all(5.0),
              child: Card(
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // three line description
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Delivery',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black38),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.play_circle_outline,
                                              color: Colors.black38,
                                            ),
                                            onPressed: null)
                                      ],
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Payment',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              Icons.check_circle,
                                              color: Colors.blue,
                                            ),
                                            onPressed: null)
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ],
                      )))),*/
          _verticalDivider(),
          Container(
              margin: EdgeInsets.all(10.0),
              child: Card(
                child: Container(
                  color: Colors.green.shade100,
                  child: Container(
                      padding:
                      const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                      child: Text(
                          "GET EXTRA 5% OFF* with MONEY bank Simply Save Credit card. T&C.",
                          maxLines: 10,
                          style: TextStyle(
                              fontSize: 13.0, color: Colors.black87))),
                ),
              )),
          new Container(
            alignment: Alignment.topLeft,
            margin:
            EdgeInsets.only(left: 12.0, top: 5.0, right: 0.0, bottom: 5.0),
            child: new Text(
              'Payment Method',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
          _verticalDivider(),
          new Container(
              height: 264.0,
              margin: EdgeInsets.all(10.0),
              child: Card(
                child: Container(
                  child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("Wallet / UPI",
                                    maxLines: 10,
                                    style: TextStyle(
                                        fontSize: 15.0, color: Colors.black)),
                                Radio<int>(
                                    value: 0,
                                    groupValue: 0,
                                    onChanged: null),
                              ],
                            ),
                          ),
                          Divider(),
                          _verticalD(),
                          /*Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Net Banking",
                                      maxLines: 10,
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black)),
                                  Radio<int>(
                                      value: 0,
                                      groupValue: radioValue,
                                      onChanged: null),
                                ],
                              )),*/
                      Divider(),
                          _verticalD(),
                          /* Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                              Text("Credit / Debit / ATM Card",
                                  maxLines: 10,
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.black)),
                              Radio<int>(
                                  value: 0, groupValue: 0, onChanged: null),
                            ],
                              )),*/
                          Divider(),
                          _verticalD(),
                          Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("Cash on Delivery",
                                      maxLines: 10,
                                      style: TextStyle(
                                          fontSize: 15.0, color: Colors.black)),
                                  Radio<int>(
                                      value: 0,
                                      groupValue: 0,
                                      onChanged: handleRadioValueChanged),
                                ],
                              )),
                          Divider(),
                        ],
                      )),
                ),
              )),
          Container(
              alignment: Alignment.bottomLeft,
              height: 50.0,
              child: Card(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.info), onPressed: null),
                    Text(
                      'Total :',
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\₹ ${totalPrice}',
                      style: TextStyle(fontSize: 17.0, color: Colors.black54),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: Alignment.center,
                        child: OutlineButton(
                            borderSide: BorderSide(color: Colors.green),
                            child: const Text('PROCEED TO Order'),
                            textColor: Colors.green,
                            onPressed: () {
                              DataCollection().addCustomerCartToDatabase(
                                  Custom_AppBar().getCartList(), totalPrice);
                              new Timer(new Duration(seconds: 1), () {
                                debugPrint("Print after 5 seconds");
                                DataCollection().getOrderHistoryList();
                              });
                              new Timer(new Duration(seconds: 1), () {
                                debugPrint("Print after 5 seconds");
                                Custom_AppBar().clearCart();
                              });

                              //Order_Service().placeOrder();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OderHistory_Screen()));
                            },
                            shape: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            )),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  _verticalDivider() => Container(
    padding: EdgeInsets.all(2.0),
  );

  _verticalD() => Container(
    margin: EdgeInsets.only(left: 5.0),
  );
}
