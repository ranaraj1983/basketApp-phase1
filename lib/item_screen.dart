import 'dart:math';

import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/item_details.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Item_Screen extends StatefulWidget {
  String categoryName;

  Item_Screen(this.categoryName);

  @override
  _itemPageState createState() => _itemPageState(categoryName);
}

class _itemPageState extends State<Item_Screen> {
  _itemPageState(categoryName);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
      backgroundColor: Colors.indigo[50],
      key: _scaffoldKey,
      drawer: Navigation_Drawer(new Auth()),
      bottomNavigationBar:
          Custom_AppBar().getButtomNavigation(context, firebaseUser),
      appBar: Custom_AppBar().getAppBar(context),
      body: _getItemByCategory(widget.categoryName, context),
    );
  }

  Widget _getItemByCategory(String categoryName, BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: DataCollection().getSubCollection(categoryName),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading...."),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return GridView.builder(
                  padding: EdgeInsets.all(8.0),
                  itemCount: snapshot.data.length,
                  primary: true,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.8),
                  itemBuilder: (context, index) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading...."),
                      );
                    } else {
                      return Card(
                        child: Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Item_Details(
                                          toolbarname: snapshot
                                              .data[index].data['itemName'],
                                          dataSource: snapshot.data[index],
                                        )));
                              },
                              child: WidgetFactory().getImageFromDatabase(
                                  context,
                                  snapshot.data[index].data['imageUrl']),
                            ),
                            Text(
                              snapshot.data[index].data['itemName'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "QTN " + snapshot.data[index].data['unit'],
                            ),
                            Text(
                              "Price \₹ " + snapshot.data[index].data['price'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () {
                                    int random = new Random().nextInt(100000);
                                    Custom_AppBar().addItemToCart(
                                        snapshot.data[index].data['itemId'],
                                        snapshot.data[index].data['itemName'],
                                        snapshot.data[index].data['imageUrl'],
                                        snapshot
                                            .data[index].data['description'],
                                        1.toString(),
                                        snapshot.data[index].data['price'],
                                        random.toString() +
                                            "_" +
                                            snapshot
                                                .data[index].data['itemName']);
                                  },
                                  //color: Colors.amber,
                                  textColor: Colors.white,
                                  highlightColor: Colors.black,
                                  splashColor: Colors.green,
                                  color: Colors.pinkAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text("Add"),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                  });
            } else {
              return Container();
            }
          }),
    );
  }
}
