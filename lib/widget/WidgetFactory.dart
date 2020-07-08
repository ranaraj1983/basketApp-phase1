import 'dart:math';

import 'package:basketapp/HomeScreen.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetFactory {
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

  Widget getSearchListView(BuildContext context, var categorySnapshot, var itemSnapshot) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            child: new FittedBox(
              child: Material(
                color: Colors.white,
                elevation: 14.0,
                borderRadius: BorderRadius.circular(24.0),
                shadowColor: Color(0x802196F3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0.0),
                        child: _populateSearList(
                            context, categorySnapshot, itemSnapshot),
                      ),
                    ),
                    //getImageFromDatabase(context,itemSnapshot.data['imageUrl']),
                    Container(
                      width: 250,
                      height: 200,
                      child: getImageFromDatabase(
                          context, itemSnapshot.data['imageUrl']),
                    ),
                    Container(
                      width: 250,
                      height: 200,
                      child: addToCartButton(itemSnapshot),
                    ),
                  ],
                ),
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
                            validator: (val) => !val.contains('@')
                                ? 'Not a valid email.'
                                : null,
                            onSaved: (val) => formKey.currentState
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


  Widget getImageFromDatabase(BuildContext context, String imageUrl) {
    return FutureBuilder(
        future: DataCollection().getImageFromStorage(
            context, imageUrl, 100, 100),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ClipRRect(

              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              child: Stack(

                children: <Widget>[
                  snapshot.data == null
                      ? Image.network(
                      'https://www.fakenamegenerator.com/images/sil-female.png')
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
        });
  }

  Widget _populateSearList(BuildContext context, var categorySnapshot, var itemSnapshot) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: <Widget>[
                Text(
                  itemSnapshot.data['itemName'],
                  style: GoogleFonts.aBeeZee(
                    //textStyle: Theme.of(context).textTheme.headline5,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      "\₹" + itemSnapshot.data['price'],
                      style: GoogleFonts.aBeeZee(
                        //textStyle: Theme.of(context).textTheme.headline5,
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ]),
            ),
          ),
        ]);
  }

  Widget addToCartButton(itemSnapshot) {
    int quantity = 1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        alignment: Alignment.center,
        child: OutlineButton(
            borderSide: BorderSide(color: Colors.amber.shade500),
            child: const Text('Add'),
            textColor: Colors.amber.shade500,
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
                        user,
                        user.displayName,
                        street,
                        city,
                        district,
                        mobilenumber,
                        state,
                        pincode);
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
            content: Form(
                key: formKey,
                autovalidate: false,
                child: SingleChildScrollView(
                    child: Column(
                        children: <Widget>[
                          Text("${user.displayName}"),
                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Street Name'),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter Street Name';
                              }
                            },
                            onSaved: (val) =>
                                formKey.currentState.setState(() =>
                                street = val),
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
                                formKey.currentState.setState(() =>
                                district = val),
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
                                formKey.currentState.setState(() =>
                                pincode = val),
                          ),

                          TextFormField(
                            decoration: InputDecoration(
                                labelText: 'mobile number'),
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

  Widget getCustomerAddress(
      BuildContext context, GlobalKey<FormState> formKey) {
    return Container(
        height: 165.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
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
                            icon: Icon(Icons.add), onPressed: () {
                          WidgetFactory().addAddressDialog(context, formKey);
                        }
                        )
                    ),
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
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Text("Loading...."),
                              );
                            } else {
                              return Container(
                                margin: EdgeInsets.only(
                                    left: 12.0,
                                    top: 5.0,
                                    right: 0.0,
                                    bottom: 5.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data['displayName'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data['mobileNumber'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),
                                      Text(
                                        snapshot.data['street'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),
                                      Text(
                                        snapshot.data['city'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),
                                      Text(
                                        snapshot.data['district'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),
                                      Text(
                                        snapshot.data['pincode'],
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      //_verticalDivider(),


                                    ]
                                ),
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
        )
    );
  }
}
