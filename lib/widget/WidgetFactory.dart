import 'dart:async';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basketapp/HomeScreen.dart';
import 'package:basketapp/OderHistory_Screen.dart';
import 'package:basketapp/Payment_Screen.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/item_details.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scratcher/scratcher.dart';

class WidgetFactory {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Widget getCategoryInHomePage(BuildContext context) {
    var categoryList = DataCollection().getCategories();
    categoryList.then((value) {
      return value.documents.forEach((element) {
        return Text(element.documentID);
        //element.documentID;
        print(element.documentID);
      });
    });
  }

  Widget getSearchListView(
      BuildContext context, var categorySnapshot, var itemSnapshot) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        SingleChildScrollView(
          child: Card(
            color: Colors.indigo,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Item_Details(
                              toolbarname: itemSnapshot.data['itemName'],
                              dataSource: itemSnapshot,
                            )));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _populateSearchList(
                            context, categorySnapshot, itemSnapshot),
                      ),
                      Expanded(
                        child: getImageFromDatabase(
                            context, itemSnapshot.data['imageUrl']),
                      ),
                      Expanded(
                        child: addToCartButton(itemSnapshot),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  logInDialog(BuildContext context) {
    String _email;
    String _password;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Log In'),
                onPressed: () async {
                  final form = formKey.currentState;
                  //form.context.widget.
                  if (form.validate()) {
                    form.save();

                    // Email & password matched our validation rules
                    // and are saved to _email and _password fields.
                    FirebaseUser user = await new Auth()
                        .signIn(_email, _password)
                        .catchError((e) {
                      scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text("invalid user credential")));
                    });

                    debugPrint(
                        "inside log in function _performLogin: " + user.uid);
                    user == null
                        ? scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text("invalid user in")))
                        : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home_screen()));
                  }
                },
              ),
            ],
            content: Container(
              height: 300,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Form(
                    key: formKey,
                    autovalidate: false,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black87,
                                      style: BorderStyle.solid),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black87,
                                      style: BorderStyle.solid),
                                ),
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.black38,
                                ),
                                hintText: 'Your email address',
                                labelText: 'E-mail',
                                labelStyle: TextStyle(color: Colors.black54)),
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) =>
                            !val.contains('@')
                                ? 'Not a valid email.'
                                : null,
                            onSaved: (val) =>
                                formKey.currentState
                                    .setState(() => _email = val),
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black87,
                                      style: BorderStyle.solid),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.black87,
                                      style: BorderStyle.solid),
                                ),
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.black38,
                                ),
                                hintText: 'Your password',
                                labelText: 'Password',
                                labelStyle: TextStyle(color: Colors.black54)),
                            validator: (val) =>
                            val.length < 6 ? 'Password too short.' : null,
                            onSaved: (val) => _password = val,
                          ),
                        ],
                      ),
                    ),
                  ),

                  //const SizedBox(height: 24.0),
                ],
              ),
            ),
          );
        });

    //showDialog(context: context, builder: (_) => alert);
  }

  Widget getImageFromDatabaseByGoogle(String imageUrl) {
    return Image.network(imageUrl);
  }

  Widget getImageFromDatabase(BuildContext context, String imageUrl) {
    return (imageUrl == null
        ? Container(
        height: 100,
        width: 100,
        child: Image.asset("images/noprofileimage.png"))
        : FutureBuilder(
        future: DataCollection()
            .getImageFromStorage(context, imageUrl, 100, 100),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Stack(
                children: <Widget>[
                  snapshot.data == null
                      ? Container(
                      height: 100,
                      width: 100,
                      child: Image.asset("images/noprofileimage.png"))

                  /*Image.network(
                          'https://www.fakenamegenerator.com/images/sil-female.png')*/
                      : snapshot.data,
                  //snapshot.data,
                ],
              ),
            );
          } else {
            return Container(
              child: CircularProgressIndicator(),
            );
          }
        }
    )
    );
  }

  Widget emptyWidget() {
    return Container(
      child: Text("No Item Added"),
    );
  }

  Widget populateCartList(BuildContext context) {
    return Column(
      children: [
        Container(
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              //shrinkWrap: true,
              itemCount: cartCounter.cartList.length,
              itemBuilder: (BuildContext context, int index) {
                int quan = int.parse(cartCounter.cartList[index].quantity);
                int price = int.parse(cartCounter.cartList[index].price);
                int total = quan * price;

                return Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(
                            left: 10, bottom: 10, right: 10, top: 10),
                        margin: new EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Image.network(
                                  cartCounter.cartList[index].imageUrl,
                                  fit: BoxFit.fitWidth,
                                  width: 100,
                                  height: 100,
                                )),
                            Expanded(
                              child: Column(
                                children: [
                                  Wrap(
                                    children: [
                                      Text(cartCounter.cartList[index].itemName,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(cartCounter.cartList[index].quantity,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold)),
                                      Text("X"),
                                      Text(cartCounter.cartList[index].price,
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold)),
                                      Text(" = " + total.toString() + ""),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        tooltip: "Delete Item",
                                        icon: Icon(Icons.delete_forever,
                                            color: Colors.red, size: 35),
                                        onPressed: () =>
                                        {
                                          print(cartCounter
                                              .cartList[index].itemId),
                                          Custom_AppBar().removeItemFromCart(
                                              cartCounter
                                                  .cartList[index].itemName),
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Divider(height: 15.0),
                );
              }),
        ),
        cartCounter.cartList.length > 0
            ? _addConfirmButtom(context)
            : Container(),
      ],
    );
  }

  Widget _addConfirmButtom(BuildContext context) {
    return Container(
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

          Observer(
            builder: (_) =>
                Stack(
                  children: <Widget>[
                    Text(
                      '\₹ ${cartCounter.totalPrice.value}',
                      style: TextStyle(fontSize: 17.0, color: Colors.black54),
                    ),
                  ],
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: OutlineButton(
                  borderSide: BorderSide(color: Colors.amber.shade500),
                  child: const Text('CONFIRM ORDER'),
                  textColor: Colors.amber.shade500,
                  onPressed: () async {
                    if (cartCounter.getTotal >= 500) {
                      if (await Auth().getCurrentUserFuture() != null) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Payment_Screen()
                            )
                        );
                      } else {
                        WidgetFactory().logInDialog(context);
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Order Price Alert"),
                              content: Text(
                                  "Your order value is less than 500"
                                      " rupees kindly add more product or 50 rupees "
                                      "delivery charges will be added to your order"
                                      " value"
                              ),
                              actions: [
                                FlatButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Payment_Screen()
                                        )
                                    );
                                  },
                                )

                              ]
                              ,
                            );
                          }
                      );
                    }
                  },
                  shape: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _populateSearchList(BuildContext context, var categorySnapshot,
      var itemSnapshot) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Wrap(
            children: [
              Text(
                itemSnapshot.data['itemName'],
                style: GoogleFonts.roboto(
                  //textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  //fontStyle: FontStyle.normal,
                  color: Colors.yellowAccent,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
          Wrap(
            children: [
              Text(
                "\₹" + itemSnapshot.data['price'],
                style: GoogleFonts.roboto(
                  //textStyle: Theme.of(context).textTheme.headline5,
                  fontSize: 25,
                  color: Colors.yellowAccent,
                  //fontWeight: FontWeight.w400,
                  //fontStyle: FontStyle.normal,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ]);
  }

  Widget addToCartButton(itemSnapshot) {
    int quantity = 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        alignment: Alignment.center,
        child: RaisedButton(
            color: Colors.yellowAccent,
            child: const Text('Add'),
            textColor: Colors.black,
            onPressed: () {
              int random = new Random().nextInt(1000);
              if (quantity <= 0) quantity = 1;
              Custom_AppBar().addItemToCart(
                  itemSnapshot.data['itemId'],
                  itemSnapshot.data['itemName'],
                  itemSnapshot.data['imageUrl'],
                  itemSnapshot.data['description'],
                  quantity.toString(),
                  (int.parse(itemSnapshot.data['price']) * quantity).toString(),
                  random.toString() + "_" + itemSnapshot.data['itemName']);
            },
            shape: new OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
      ),
    );
  }

  Future<void> addAddressDialog(BuildContext context,
      GlobalKey<FormState> formKey) async {
    FirebaseUser user = await new Auth().getCurrentUser();
    String userId;
    String name;
    String mobilenumber;
    String street;
    String city;
    String district;
    String state;
    String pincode;

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Add'),
                onPressed: () {
                  final form = formKey.currentState;
                  //form.context.widget.
                  if (form.validate()) {
                    form.save();

                    DataCollection().addAddress(
                        user.uid,
                        user.displayName,
                        street,
                        city,
                        district,
                        mobilenumber,
                        state,
                        pincode,
                        user.email,
                        "India");
                  }

                },
              ),
            ],
            content: Form(
                key: formKey,
                autovalidate: false,
                child: SingleChildScrollView(
                    child: Column(children: <Widget>[
                      Text("${user.displayName}"),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Street Name'),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Street Name';
                          }
                        },
                        onSaved: (val) =>
                            formKey.currentState.setState(() => street = val),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'City'),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter City Name';
                          }
                        },
                        onSaved: (val) =>
                            formKey.currentState.setState(() => city = val),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'District'),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter district Name';
                          }
                        },
                        onSaved: (val) =>
                            formKey.currentState.setState(() => district = val),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'pincode'),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter pincode Name';
                          }
                        },
                        onSaved: (val) =>
                            formKey.currentState.setState(() => pincode = val),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'mobile number'),
                        // ignore: missing_return
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter phone number';
                          }
                        },
                        onSaved: (val) =>
                            formKey.currentState.setState(() =>
                            mobilenumber = val),
                      ),
                    ]))),
          );
        });
  }

  Widget getCustomerAddress(BuildContext context,
      GlobalKey<FormState> formKey) {
    return Container(
        height: 165.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: <Widget>[
            Container(
              height: 165.0,
              width: 56.0,
              child: Card(
                elevation: 3.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        alignment: Alignment.center,
                        child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              WidgetFactory()
                                  .addAddressDialog(context, formKey);
                            })),
                  ],
                ),
              ),
            ),
            Container(
              height: 165.0,
              width: 200.0,
              margin: EdgeInsets.all(7.0),
              child: Card(
                elevation: 3.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Column(
                      children: <Widget>[
                        FutureBuilder(
                          future: DataCollection().getUserDetails(),
                          builder: (_, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: Text("Kindly add Your address..."),
                              );
                            }
                            else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Text("Loading...."),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error"),
                              );
                            }
                            else {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 12.0,
                                    top: 5.0,
                                    right: 0.0,
                                    bottom: 5.0),
                                child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data['displayName'] == null
                                            ? ""
                                            : snapshot.data['displayName'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data['mobileNumber'] == null
                                            ? ""
                                            : snapshot.data['mobileNumber'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),
                                      Text(
                                        snapshot.data['street'] == null
                                            ? ""
                                            : snapshot.data['street'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),
                                      Text(
                                        snapshot.data['city'] == null
                                            ? ""
                                            : snapshot.data['city'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),
                                      Text(
                                        snapshot.data['district'] == null
                                            ? ""
                                            : snapshot.data['district'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),
                                      Text(
                                        snapshot.data['pin'] == null
                                            ? ""
                                            : snapshot.data['pin'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),
                                    ]),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }


  Future<Placemark> getAddressFromLatLng() async {
    Position _currentPosition = await geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      return place;
    } catch (e) {
      print(e);
    }
  }

  Future<void> scratchCardDialog(BuildContext context, int totalPrice) async {
    int offerPrice = totalPrice ~/ 90;

    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.RIGHSLIDE,
      headerAnimationLoop: false,
      title: 'You\'ve won a scratch card',
      desc: "error.toString()",
      btnOkOnPress: () async {
        CircularProgressIndicator(
          backgroundColor: Colors.yellowAccent,
        );
        await DataCollection().addOrder(
            Custom_AppBar().getCartList(), totalPrice, true,
            Custom_AppBar().getRedeemAmount()).then((value) =>
        {
          DataCollection().addOfferToCustomrWalet(offerPrice),


        }).whenComplete(() =>
        {

          Custom_AppBar().clearCart(),
          //Custom_AppBar().clearRedeemMap(),
          DataCollection().updateWalletTable(Custom_AppBar().getRedeemMap()),

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OderHistory_Screen()
              )
          ),

        });


        /* */
      },
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
      body: Scratcher(
        accuracy: ScratchAccuracy.low,
        threshold: 25,
        brushSize: 50,
        onThreshold: () {},
        image: Image.asset("images/diamond_bw.png"),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 250),
          opacity: 1,
          child: Container(
            height: 300,
            width: 300,
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Text('You\'ve won a scratch card'),
                Text(
                  "INR " + (offerPrice).toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                      color: Colors.blue),
                ),
              ],
            ),
          ),
        ),
      ),
    ).show();
  }
}
