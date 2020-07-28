import 'dart:async';
import 'dart:io';

import 'package:basketapp/Util/PdfGenerator.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/model/Product_Item.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pdf;

class OderHistory_Screen extends StatefulWidget {
  final String toolbarname;

  OderHistory_Screen({Key key, this.toolbarname}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrderHistory_Screen(toolbarname);
}

class _OrderHistory_Screen extends State<OderHistory_Screen> {
  VoidCallback _showBottomSheetCallback;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String toolbarname;

  _OrderHistory_Screen(this.toolbarname);

  String filePath;
  String appDocPath;
  List<Product_Item> listItem = new List<Product_Item>();

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

  _generatePdfAndView(BuildContext context, var itemData) async {
    print(itemData);
    PdfGenerator().generateInvoice(itemData, firebaseUser);
    /* final pdf.Document doc = pdf.Document(deflate: zlib.encode);
    print(itemData);
    doc.addPage(
      pdf.Page(
        build: (pdf.Context context) => pdf.Center(
          child: pdf.Container(
            child: pdf.Column(children: [
              pdf.Text(itemData['orderId']),

            ]),
          ),
        ),
      ),
    );
    final String dirPath = (await getApplicationDocumentsDirectory()).path;
    //final String path = dir.path;
    var orderId = itemData['orderId'];
    final File file = File('$dirPath/order_${orderId}.pdf');
    file.writeAsBytes(doc.save());
    //Launch the file (used open_file package)
    OpenFile.open('$dirPath/order_${orderId}.pdf');*/

    //final String exDir = (await getExternalStorageDirectory()).path;
/*    final String path = '$dir/order_${itemData['orderId']}.pdf';
    final File file = File(path);
    await file.writeAsBytes(doc.save());
    OpenFile.open('$path/order_${itemData['orderId']}.pdf');
    print(exDir + " :: " + path);*/
    /*Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
      ),
    );*/
  }

  void prepareDirPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Stream<FileSystemEntity> files = appDocDir.list();

    files.listen((data) {
      print("Data: " + data.toString());
    });

    final doc = pdf.Document();
    doc.addPage(
      pdf.Page(
        build: (pdf.Context context) => pdf.Center(
          child: pdf.Text('Hello World!'),
        ),
      ),
    );

    appDocPath = appDocDir.path;
    filePath = "$appDocPath/text.txt";
    Directory output = await getTemporaryDirectory();
    final file = File('${appDocPath}/example.pdf');
    file.writeAsBytesSync(doc.save());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;

    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Scaffold(
      key: _scaffoldKey,
      drawer: Navigation_Drawer(new Auth()),
      bottomNavigationBar:
          Custom_AppBar().getBottomNavigation(context, firebaseUser),
      appBar: Custom_AppBar().getAppBar(context),
      body: _getOrderHistoryPage(context),
    );
  }

  Widget _getOrderHistoryPage(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: DataCollection().getOrderHistoryList(),
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Loading...."),
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              var itemData = snapshot.data.documents[index].data;
              // print(DateTime.parse(itemData['orderDate'].toDate().toString()).toLocal().toString());

              return Container(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        _getAlertDialog(
                            context, snapshot.data.documents[index].documentID);
                      },
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(itemData['orderId'] +
                                    "\n \n Date " +
                                    DateTime.parse(itemData['orderDate']
                                        .toDate()
                                        .toString())
                                        .toLocal()
                                        .toString()),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Text(""),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  RaisedButton(
                                    onPressed: () {
                                      _generatePdfAndView(context, itemData);
                                    },
                                    child: Text("Invoice"),
                                  ),
                                  /*RaisedButton(
                                    onPressed: () {
                                      _cancelOrder(
                                          context, itemData);
                                      print("clicked");
                                    },
                                    child: Text("Cancel"),
                                  ),*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  _verticalDivider() => Container(
        padding: EdgeInsets.all(2.0),
      );

  Widget _status(status) {
    if (status == 'Cancel Order') {
      return FlatButton.icon(
          label: Text(
            status,
            style: TextStyle(color: Colors.red),
          ),
          icon: const Icon(
            Icons.highlight_off,
            size: 18.0,
            color: Colors.red,
          ),
          onPressed: () {
            // Perform some action
          });
    } else {
      return FlatButton.icon(
          label: Text(
            status,
            style: TextStyle(color: Colors.green),
          ),
          icon: const Icon(
            Icons.check_circle,
            size: 18.0,
            color: Colors.green,
          ),
          onPressed: () {
            // Perform some action
          });
    }
    if (status == "3") {
      return Text('Process');
    } else if (status == "1") {
      return Text('Order');
    } else {
      return Text("Waiting");
    }
  }

  erticalD() => Container(
        margin: EdgeInsets.only(left: 10.0, right: 0.0, top: 0.0, bottom: 0.0),
      );

  bool a = true;
  String mText = "Press to hide";
  double _lowerValue = 1.0;
  double _upperValue = 100.0;

  void _visibilitymethod() {
    setState(() {
      if (a) {
        a = false;
        mText = "Press to show";
      } else {
        a = true;
        mText = "Press to hide";
      }
    });
  }

  void _cancelOrder(BuildContext context, itemData) {
    DataCollection().cancelCustomerOrder(itemData);
  }

  void _getAlertDialog(BuildContext context, String docId) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      scrollable: true,
      title: Text("My Orderlist ${docId}"),
      content: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
                future: DataCollection().getSubCollectionOfOrder(docId),
                builder: (_, snp) {
                  if (snp.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snp.data.documents.length,
                      itemBuilder: (context, index) {
                        var itemData = snp.data.documents[index].data;
                        int tVal = int.parse(itemData['price']) *
                            int.parse(itemData['quantity']);
                        return
                          Container(

                            child: Row(

                              children: [

                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: WidgetFactory().getImageFromDatabase(
                                        context, itemData['imageUrl']),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                        itemData['itemName']),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                      itemData['price'] + " X " +
                                          itemData['quantity'] + " = " +
                                          tVal.toString()

                                  ),
                                ),

                              ],
                            ),

                          );
                      },
                    );
                  }
                }),
          ],
        ),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
