import 'dart:math';

import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Item_Details extends StatefulWidget {
  //Item_Details(data);
  DocumentSnapshot dataSource;
  String toolbarname;

  Item_Details({Key key, this.toolbarname, this.dataSource}) : super(key: key);

  @override
  State<StatefulWidget> createState() => item_details(toolbarname, dataSource);
}

class item_details extends State<Item_Details> {
  String toolbarname;
  DocumentSnapshot dataSource;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int quantity = 1;
  int item = 0;

  item_details(this.toolbarname, this.dataSource);

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
    String itemId = this.dataSource.data['itemId'];

    void minus() {
      setState(() {
        if (quantity > 1) quantity--;
      });
    }

    void add() {
      setState(() {
        quantity++;
        print(quantity);
      });
      print(quantity);
    }

    print(quantity);

    // TODO: implement build
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
    theme.textTheme.headline5.copyWith(color: Colors.white);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
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

    IconData _add_icon() {
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          return Icons.add_circle;
        case TargetPlatform.iOS:
          return Icons.add_circle;
      }
      assert(false);
      return null;
    }

    IconData _sub_icon() {
      switch (Theme.of(context).platform) {
        case TargetPlatform.android:
        case TargetPlatform.fuchsia:
          return Icons.remove_circle;
        case TargetPlatform.iOS:
          return Icons.remove_circle;
      }
      assert(false);
      return null;
    }

    return new Scaffold(
        key: _scaffoldKey,
        drawer: Navigation_Drawer(new Auth()),
        bottomNavigationBar:
            Custom_AppBar().getButtomNavigation(context, firebaseUser),
        appBar: Custom_AppBar().getAppBar(context),
        body: Container(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Card(
                elevation: 4.0,
                child: Container(
                  color: Colors.white,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // photo and title
                            SizedBox(
                              height: 250.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  WidgetFactory().getImageFromDatabase(
                                      context, this.dataSource.data['imageUrl']),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: DefaultTextStyle(
                          style: descriptionStyle,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // three line description
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  this.dataSource.data['itemName'],
                                  style: descriptionStyle.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  "\₹ " + this.dataSource.data['price'],
                                  style: descriptionStyle.copyWith(
                                      fontSize: 20.0, color: Colors.black54),
                                ),
                              ),
                            ],
                          ))),
                  Container(
                      margin: EdgeInsets.all(10.0),
                      child: Card(
                          child: Container(
                              padding:
                              const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                              child: DefaultTextStyle(
                                  style: descriptionStyle,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      // three line description
                                      Row(
                                        children: <Widget>[
                                          new IconButton(
                                              icon: Icon(_add_icon(),
                                                  color: Colors.amber.shade500),
                                              onPressed: () => add()),
                                          Container(
                                            margin: EdgeInsets.only(left: 2.0),
                                          ),
                                          Text("$quantity"),
                                          Container(
                                            margin: EdgeInsets.only(right: 2.0),
                                          ),
                                          new IconButton(
                                              icon: Icon(_sub_icon(),
                                                  color: Colors.amber.shade500),
                                              onPressed: () => minus()),
                                        ],
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: RaisedButton(
                                            textColor: Colors.white,
                                            highlightColor: Colors.black,
                                            splashColor: Colors.green,
                                            color: Colors.pinkAccent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(10)),
                                            child: const Text('Add'),
                                            onPressed: () {
                                          int random =
                                              new Random().nextInt(100000);

                                          if (quantity <= 0) quantity = 1;
                                          Custom_AppBar().addItemToCart(
                                              this.dataSource.data['itemId'],
                                              this.dataSource.data['itemName'],
                                              this.dataSource.data['imageUrl'],
                                              this
                                                  .dataSource
                                                  .data['description'],
                                              quantity.toString(),
                                              (int.parse(this
                                                          .dataSource
                                                          .data['price']) *
                                                      quantity)
                                                  .toString(),
                                              random.toString() +
                                                  "_" +
                                                  this
                                                      .dataSource
                                                      .data['itemName']);
                                        },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ))))),
                  Container(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: DefaultTextStyle(
                          style: descriptionStyle,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // three line description
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  'Details',
                                  style: descriptionStyle.copyWith(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87),
                                ),
                              ),
                            ],
                          ))),
                  Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),
                      child: Text(this.dataSource.data['description'],
                          maxLines: 10,
                          style: TextStyle(
                              fontSize: 13.0, color: Colors.black38))),
                ]))));
  }

  void increaseItemNumber(int quantity) {
    quantity++;
  }
}
