import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomOrder_Screen extends StatefulWidget {
  //final String toolbarname;

  //Help_Screen({Key key, this.toolbarname}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomOrder_Screen();
}

class _CustomOrder_Screen extends State<CustomOrder_Screen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser firebaseUser;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String _itemName;
  String _quantity;
  String _unit;

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
    return Scaffold(
      key: _scaffoldKey,
      drawer: Navigation_Drawer(new Auth()),
      bottomNavigationBar:
          Custom_AppBar().getButtomNavigation(context, firebaseUser),
      appBar: Custom_AppBar().getAppBar(context),
      body: Container(
        child: Card(
          shadowColor: Colors.yellow,
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 10,
                  //obscureText: true,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black87, style: BorderStyle.solid),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black87, style: BorderStyle.solid),
                      ),
                      icon: Icon(
                        Icons.lock,
                        color: Colors.black38,
                      ),
                      hintText: 'Your Item Details',
                      labelText: 'Your Item Details',
                      labelStyle: TextStyle(color: Colors.black54)),
                  onSaved: (val) => _itemName = val,
                ),
                TextFormField(
                  maxLength: 10,
                  //obscureText: true,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black87, style: BorderStyle.solid),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black87, style: BorderStyle.solid),
                      ),
                      icon: Icon(
                        Icons.lock,
                        color: Colors.black38,
                      ),
                      hintText: 'Quantity',
                      labelText: 'Quantity',
                      labelStyle: TextStyle(color: Colors.black54)),
                  onSaved: (val) => _quantity = val,
                ),
                TextFormField(
                  maxLength: 10,
                  //obscureText: true,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black87, style: BorderStyle.solid),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.black87, style: BorderStyle.solid),
                      ),
                      icon: Icon(
                        Icons.lock,
                        color: Colors.black38,
                      ),
                      hintText: 'Unit in Grm/KG/Lit',
                      labelText: 'Unit in Grm/KG/Lit',
                      labelStyle: TextStyle(color: Colors.black54)),
                  onSaved: (val) => _unit = val,
                ),
                RaisedButton(
                    child: Text("Add"),
                    onPressed: () {
                      _submitForm();
                      //DataCollection().submitCustomItem();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _submitForm() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      var out = DataCollection().addCustomItem(_itemName, _quantity, _unit);
      print(out);
    } else {
      showInSnackBar('Please fix the errors in red before submitting.');
    }
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }
}
