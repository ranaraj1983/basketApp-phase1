import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:basketapp/HomeScreen.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/model/User.dart';
import 'package:basketapp/signup_screen.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database/DataCollection.dart';
import 'package:basketapp/ForgetPassword_Screen.dart';

class Login_Screen extends StatefulWidget {
  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  const Login_Screen({Key key, this.fieldKey, this.hintText, this.labelText,
    this.helperText, this.onSaved, this.validator,
    this.onFieldSubmitted}) : super(key: key);

  ThemeData buildTheme() {
    final ThemeData base = ThemeData();
    return base.copyWith(
      hintColor: Colors.red,
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(
            color: Colors.yellow,
            fontSize: 24.0
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => login();
}

class login extends State<Login_Screen> {
  bool _rememberMe = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _autovalidate = false;
  bool _formWasEdited = false;

  String _validateName(String value) {
    _formWasEdited = true;
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

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

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.yellowAccent,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.yellowAccent,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,

            ),

            validator: (val) =>
            !val.contains('@') ? 'Not a valid email.' : null,
            onSaved: (val) => _email = val,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),

        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            style: TextStyle(
              color: Colors.yellowAccent,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.yellowAccent,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,

            ),

            validator: (val) =>
            val.length < 6 ? 'Password too short.' : null,
            onSaved: (val) => _password = val,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.yellowAccent),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.yellowAccent,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          _submit(context);
        },
        padding: EdgeInsets.all(15.0),

        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.yellowAccent,
        child: Text(
          'LOGIN',
          style: TextStyle(
            //backgroundColor: Colors.yellowAccent,
            //background: ,
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.yellowAccent,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.yellowAccent,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
/*          _buildSocialBtn(
                () {
              Auth().signupWithFacebook(context);
              print('Login with Facebook');
            } ,
            AssetImage(
              'images/facebook.jpg',
            ),
          ),*/
          _buildSocialBtn(
                () async {
              FirebaseUser fUser = await Auth().signupWithGoogle();
              fUser != null ? Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home_screen()
              )
              ) : AwesomeDialog(
                  context: context,
                  dialogType: DialogType.ERROR,
                  animType: AnimType.RIGHSLIDE,
                  headerAnimationLoop: false,
                  title: 'Login Error',
                  desc:
                  "error.toString()",
                  btnOkOnPress: () {},
                  btnOkIcon: Icons.cancel,
                  btnOkColor: Colors.red)
                  .show();
            },
            AssetImage(
              'images/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => {
        print('Sign Up Button mm'),
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Signup_Screen())),
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.yellowAccent,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.yellowAccent,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Form(
                        key: formKey,
                        autovalidate: _autovalidate,
                        child: Column(
                          children: [
                            SizedBox(height: 30.0),
                            _buildEmailTF(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildPasswordTF(),
                            _buildForgotPasswordBtn(),
                            _buildRememberMeCheckbox(),
                            _buildLoginBtn(context),
                          ],
                        ),
                      ),

                      _buildSignInWithText(),
                      _buildSocialBtnRow(context),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /* ShapeBorder shape;

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
    // TODO: implement build
    bool _obscureText = true;
    return new Scaffold(
        key: _scaffoldKey,
        drawer: Navigation_Drawer(new Auth()),
        bottomNavigationBar:
            Custom_AppBar().getButtomNavigation(context, firebaseUser),
        appBar: Custom_AppBar().getAppBar(context),
        body: SafeArea(
            child: new SingleChildScrollView(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Container(
                height: 50.0,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(top: 7.0),
                child: new Row(
                    children: <Widget>[
                      _verticalD(),
                      new GestureDetector(
                        onTap: () {


                          */ /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => login_screen()));*/ /*

                        },
                        child: new Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      _verticalD(),
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Signup_Screen()));
                      },
                        child: new Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black26,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                new SafeArea(

                    top: false,
                    bottom: false,
                    child: Card(
                        elevation: 5.0,
                        child: Form(
                            key: formKey,
                            autovalidate: _autovalidate,
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    const SizedBox(height: 24.0),
                                    TextFormField(
                                      decoration: const InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                          ),
                                          focusedBorder:  UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                          ),
                                          icon: Icon(Icons.email,color: Colors.black38,),
                                          hintText: 'Your email address',
                                          labelText: 'E-mail',
                                          labelStyle: TextStyle(color: Colors.black54)
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (val) =>
                                      !val.contains('@') ? 'Not a valid email.' : null,
                                      onSaved: (val) => _email = val,
                                    ),

                                    const SizedBox(height: 24.0),
                                    TextFormField(
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                          ),
                                          focusedBorder:  UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.black87,style: BorderStyle.solid),
                                          ),
                                          icon: Icon(Icons.lock,color: Colors.black38,),
                                          hintText: 'Your password',
                                          labelText: 'Password',
                                          labelStyle: TextStyle(color: Colors.black54)
                                      ),

                                      validator: (val) =>
                                      val.length < 6 ? 'Password too short.' : null,
                                      onSaved: (val) => _password = val,
                                    ),

                                    SizedBox(height: 35.0,),
                                    new Container(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[

                                          new Container(
                                            alignment: Alignment.bottomLeft,
                                            margin: EdgeInsets.only(left: 10.0),
                                            child: new GestureDetector(
                                              onTap: () {
                                                */ /*Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ForgetPassword_Screen()
                                                    )
                                                );*/ /*
                                              },
                                              child: Text('FORGOT PASSWORD?',style: TextStyle(
                                                  color: Colors.blueAccent,fontSize: 13.0
                                              ),),

                                            ),

                                          ),
                                          new Container(
                                            alignment: Alignment.bottomRight,
                                            child: new GestureDetector(
                                              onTap: (){
                                                _submit();
                                              },
                                              child: Text('LOGIN',style: TextStyle(
                                                  color: Colors.orange,fontSize: 20.0,fontWeight: FontWeight.bold
                                              ),
                                              ),
                                            ),
                                          ),
                                          _buildSocialBtnRow(context),
                                        ],
                                      ),
                                    ),


                                  ]
                              ),
                            )

                        )        //login,
                    ))
              ],
            ),
          )
        ));
  }*/

  void _submit(BuildContext context) {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      performLogin(_email, _password, context);
    }
    else {
      //showInSnackBar('Please fix the errors in red before submitting.');

    }
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(value)
    ));
  }

  User x = new User();

  void useValue(val){
    User u = new User(
      uid: val.uid,
      email: val.email,
      displayName: val.displayName,
      photoUrl: val.photoUrl,
    );
    x = u;

    debugPrint("this is my user value: " + x.email);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Home_screen()));
  }

  void performLogin(email, password, BuildContext context) async {
    //_getItem();
    try {
      await new Auth().signIn(email, password);

      //debugPrint("inside log in function _performLogin: " + user.uid);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Home_screen()));
    } catch (error) {
      AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: 'Login Error',
          desc:
          error.toString(),
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          btnOkColor: Colors.red)
        ..show();
    }
  }

  _verticalD() => Container(
    margin: EdgeInsets.only(left: 10.0, right: 0.0, top: 0.0, bottom: 0.0),
  );

  void handleError(e) {
    debugPrint(e);
  }


}
