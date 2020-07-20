import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ForgetPassword_Screen extends StatefulWidget {
  //final String toolbarname;

  //Help_Screen({Key key, this.toolbarname}) : super(key: key);

  @override
  _ForgetPassword_Screen createState() => _ForgetPassword_Screen();
}

class _ForgetPassword_Screen extends State<ForgetPassword_Screen> {
  FirebaseUser firebaseUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Auth().getCurrentUser().then((user) {
      setState(() {
        firebaseUser = user;
      });
    });
  }

  final kHintTextStyle = TextStyle(
    color: Colors.yellowAccent,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = TextStyle(
    color: Colors.yellowAccent,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final emailController = TextEditingController();
    bool isLoggedin = false;
    return Scaffold(
      key: _scaffoldKey,
      drawer: Navigation_Drawer(new Auth()),
      bottomNavigationBar:
          Custom_AppBar().getBottomNavigation(context, firebaseUser),
      appBar: Custom_AppBar().getAppBar(context),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFF6CA8F1),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              firebaseUser == null ? TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter email';
                  }
                  return null;
                },
              )
                  : Padding(

                padding: const EdgeInsets.symmetric(vertical: 16.0),

                child: Text(firebaseUser.email,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,

                  ),
                ),
              ),


              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  hintText: 'Enter your password',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    var email = "";
                    firebaseUser == null
                        ? email = emailController.text
                        : email = firebaseUser.email;
                    if (_formKey.currentState.validate()) {
                      Auth().resetPassword(passwordController.text);
                      // Process data.
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
