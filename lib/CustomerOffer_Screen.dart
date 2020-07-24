import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scratcher/scratcher.dart';

class CustomerOffer_Screen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CustomerOffer_Screen();
}

class _CustomerOffer_Screen extends State<CustomerOffer_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  child: Text(
                                      itemData['offerPrice'].toString() +
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
                                  child:
                                      Text(itemData['offerPrice'].toString()),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    itemData['status'] == "NEW"
                                        ? RaisedButton(
                                            onPressed: () {
                                              setState(() {
                                                redeemAmount +=
                                                    itemData['offerPrice'];
                                              });

                                              _showAlert(redeemAmount);
                                              // _generatePdfAndView(context, itemData);
                                            },
                                            child: Text("Redeem"),
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
                      );
                      Text(itemData.toString());
                    });
              }
            }));
  }

  void _showAlert(int redeemAmount) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "Congratulation",
      desc: 'You\'ve Redeemed Ruppes ${redeemAmount}',
      buttons: [
        DialogButton(
          height: 60,
          child: Text(
            "Redeem More",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "Redeem Now",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => {print("go to checkout page")},
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
    /*AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.RIGHSLIDE,
      headerAnimationLoop: false,
      title: 'You\'ve Redeemed Ruppes ${redeemAmount}' ,
      desc: 'You\'ve Redeemed Ruppes ${redeemAmount}',
      btnOkOnPress: () async{
        //redeemAmount +=itemData['offerPrice'];
      },
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,

      body: Container(
        child: Text(redeemAmount.toString()),
      ),
    )..show();*/
  }
}
