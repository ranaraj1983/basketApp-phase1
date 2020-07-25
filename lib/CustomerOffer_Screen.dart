import 'dart:collection';

import 'package:basketapp/Payment_Screen.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/widget/Cart_Counter.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final cart = Cart_Counter();

class CustomerOffer_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomerOffer_Screen();
}

class _CustomerOffer_Screen extends State<CustomerOffer_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Map redeemMap = HashMap<String, int>();
  FirebaseUser firebaseUser;
  int redeemAmount = 0;

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

    return Container(
        child: FutureBuilder(
            future: DataCollection().getCustomerOfferList(),
            builder: (_, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      var itemData = snapshot.data.documents[index].data;
                      return itemData['offerPrice'] > 0
                          ? GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                    //itemData['offerPrice'].toString() +
                                      "\n \n Date " +
                                          DateTime.parse(itemData['date']
                                              .toDate()
                                              .toString())
                                              .toLocal()
                                              .toString()),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  //decoration: kl,
                                  child: Text(
                                      itemData['offerPrice'].toString()),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    itemData['status'] == "NEW"
                                        ? !Custom_AppBar()
                                        .getRedeemMap()
                                        .containsKey(
                                        itemData['id'])
                                        ? RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          redeemAmount +=
                                          itemData[
                                          'offerPrice'];
                                        });

                                        _showAlert(itemData['offerPrice'],
                                            itemData['id'], redeemAmount);
                                        // _generatePdfAndView(context, itemData);
                                      },
                                      child: Text("Redeem"),
                                    )
                                        : RaisedButton(
                                      onPressed: null,
                                      child: Text("Redeemed"),
                                    )
                                        : RaisedButton(
                                      onPressed: null,
                                      child: Text("Redeemed"),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container();
                    });
              }
            }));
  }

  void _showAlert(int redeemAmount, String redeemId, int redeemTotalAmount) {
    var message = "You've Redeemed Rupees ";
    Alert(
      closeFunction: _checkRedeemMap(redeemId, redeemAmount),
      context: context,
      type: Custom_AppBar().isItemAdded() ? AlertType.success : AlertType.error,
      title: Custom_AppBar().isItemAdded() ? "Congratulation" : "OOps!",
      //desc: '${message} ${redeemAmount}',
      content: Custom_AppBar().isItemAdded()
          ? Text("${message} ${redeemTotalAmount}")
          : Text("Kindly add some item first"),
      buttons: [
        Custom_AppBar().isItemAdded()
            ? DialogButton(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
            child: Text(
              "Redeem More",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        )
            : DialogButton(
          height: 60,
          onPressed: null,
          child: Text("Redeem More",
            style: TextStyle(color: Colors.white, fontSize: 20),),
        ),
        Custom_AppBar().isItemAdded()
            ? DialogButton(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
            child: Text(
              "Redeem Now",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          onPressed: () =>
          {
            //var test = "";

            if (Custom_AppBar().isItemAdded())
              {
                Custom_AppBar().setRedeemValue(redeemAmount),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Payment_Screen())),
              }
            else
              {


                //_getSnackbar(context),
              },
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
            : DialogButton(
          onPressed: null,
          height: 60,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
      ],
    ).show();
  }

  _getSnackbar(BuildContext context) {
    var snackBar = SnackBar(
      content: Text('Yay! A SnackBar!'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _checkRedeemMap(String redeemId, int redeemAmount) {
    if (Custom_AppBar().isItemAdded()) {
      Custom_AppBar().setRedeemMap(redeemId, redeemAmount);
      setState(() {
        redeemMap.length == 0
            ? redeemMap = {redeemId: redeemAmount}
            : redeemMap.putIfAbsent(redeemId, () => redeemAmount);
        print(Custom_AppBar().getRedeemMap().toString() + " inside normal" +
            redeemMap.toString());
      });
    }
  }
}
