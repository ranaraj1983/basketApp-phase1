import 'dart:async';

import 'package:basketapp/CustomerOffer_Screen.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/item_details.dart';
import 'package:basketapp/item_screen.dart';
import 'package:basketapp/OderHistory_Screen.dart';
import 'package:basketapp/services/Order_Service.dart';
import 'package:basketapp/widget/Cart_Counter.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Payment_Screen extends StatefulWidget {


  Payment_Screen();

  @override
  State<StatefulWidget> createState() => _Paymet_Screen();
}

class _Paymet_Screen extends State<Payment_Screen> {
  int totalPrice = Custom_AppBar().getTotalPrice();
  Map redeemAmountMap = Custom_AppBar().getRedeemMap();
  int redeemAmount = 0;

  _Paymet_Screen();

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
        redeemAmountMap.values.forEach((element) {
          redeemAmount += element;
        });
        firebaseUser = user;
      });
    });
    print("final redeem value :: " + redeemAmount.toString());
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
      bottomNavigationBar:
          Custom_AppBar().getBottomNavigation(context, firebaseUser),
      appBar: Custom_AppBar().getAppBar(context),
      body: new Column(
        children: <Widget>[

          _verticalDivider(),
          Container(
              margin: EdgeInsets.all(10.0),
              child: Card(
                child: Container(
                  color: Colors.green.shade100,
                  child: Container(
                      padding:
                          const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                      child: Text("Only Cash On delivery",
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
              //height: 264.0,
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

                          Divider(),
                          _verticalD(),

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
              //height: 100.0,
              child: Card(
                child: totalPrice >= 500
                    ? _onlyTotalPrice()
                    : _totalPriceWithCourierCharge(),
              )),
        ],
      ),
    );
  }

  Widget _onlyTotalPrice() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(icon: Icon(Icons.info), onPressed: null),
        Expanded(
          child: Text(
            'Total : ${totalPrice} - ${redeemAmount} = \₹ ${totalPrice -
                redeemAmount}',
            style: TextStyle(
                fontSize: 17.0,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
        ),


        Expanded(

          child: Container(
            alignment: Alignment.topRight,
            child: OutlineButton(
                borderSide: BorderSide(color: Colors.green),
                child: const Text('PROCEED TO Order'),
                textColor: Colors.green,
                onPressed: () {
                  _getScrachCardPopup(context, totalPrice);

                },
                shape: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                )),
          ),
        ),
      ],
    );
  }

  Widget _totalPriceWithCourierCharge() {
    return cartCounter.cartList.length > 0 ? Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      verticalDirection: VerticalDirection.down,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            IconButton(icon: Icon(Icons.info), onPressed: null),
            Text(
              'Total :',
              style: TextStyle(
                  fontSize: 17.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              ' ${totalPrice} ',
              style: TextStyle(fontSize: 17.0, color: Colors.black54),
            ),
            Text(
              ' - ',
              style: TextStyle(fontSize: 17.0, color: Colors.black54),
            ),
            Text(
              ' ${redeemAmount}',
              style: TextStyle(fontSize: 17.0, color: Colors.black54),
            ),
            Text(
              ' + 50 = \₹ ${(totalPrice - redeemAmount) + 50}',
              style: TextStyle(fontSize: 17.0, color: Colors.black54),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.center,
                child: OutlineButton(
                    borderSide: BorderSide(color: Colors.green),
                    child: const Text('PROCEED TO ORDER'),
                    textColor: Colors.green,
                    onPressed: () {
                      _getScrachCardPopup(context, totalPrice);
                      /* DataCollection().addOrder(
                          Custom_AppBar().getCartList(), totalPrice, true);
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
                              builder: (context) => OderHistory_Screen()));*/
                    },
                    shape: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    )),
              ),
            ),
          ],
        ),
      ],
    )
        : Container();
  }

  _verticalDivider() =>
      Container(
        padding: EdgeInsets.all(2.0),
      );

  _verticalD() =>
      Container(
        margin: EdgeInsets.only(left: 5.0),
      );

  void _getScrachCardPopup(BuildContext context, int totalPrice) {
    WidgetFactory().scratchCardDialog(context, totalPrice);
  }
}
