import 'package:basketapp/HomeScreen.dart';

//import 'package:basketapp/model/ItemProduct.dart';
import 'package:basketapp/model/Product_Item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  ObservableList<Product_Item> addtoCartList =
      new ObservableList<Product_Item>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(

        brightness: Brightness.light,
        //fontFamily: 'Raleway',

        primaryColor: Colors.indigo,
        //primaryColorDark: Colors.white30,
        //accentColor: Colors.blue,
        //bottomAppBarColor: Colors.blue,
        textTheme: GoogleFonts.oxygenTextTheme(
          Theme.of(context).textTheme,
        ),
      ),

      //home: new Item_Screen(),
      home: new MyHomePage(title: 'Go Mudi Grocery Shop'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home_screen()));

  }

  @override
  void initState() {
    super.initState();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build


    return new Container(
      alignment: Alignment.center,
      decoration: new BoxDecoration(color: Colors.white),
      child: new Container(
        color: Colors.black12,
        margin: new EdgeInsets.all(30.0),
        width: 250.0,
        height: 250.0,
        child: new Image.asset(
          'images/gro_TEST.jpg',
        ),
      ),
    );
  }

}
