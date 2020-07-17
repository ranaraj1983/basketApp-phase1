import 'package:basketapp/PopularPage_Screen.dart';
import 'package:basketapp/WhatsNew_Screen.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/item_screen.dart';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/Custom_Drawer.dart';
import 'package:basketapp/widget/Navigation_Drwer.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

const String _kGalleryAssetsPackage = 'flutter_gallery_assets';

class Home_screen extends StatefulWidget {
  //final Auth auth;

  @override
  State<StatefulWidget> createState() => new home();
// TODO: implement createState

}

class Photo {
  Photo({
    this.assetName,
    this.assetPackage,
    this.title,
    this.caption,
  });

  final String assetName;
  final String assetPackage;
  final String title;
  final String caption;
}

class home extends State<Home_screen> {
  List list = ['12', '11', '2'];

  List<Photo> photos = <Photo>[
    Photo(
      assetName: 'images/veg.jpg',
      title: 'Fruits & Vegetables',
    ),
    Photo(
      assetName: 'images/frozen.jpg',
      title: 'Frozen Veg',
    ),
    Photo(
      assetName: 'images/bev.jpg',
      title: 'Beverages',
    ),
    Photo(
      assetName: 'images/brand_f.jpg',
      title: 'Brannded Food',
    ),
    Photo(
      assetName: 'images/be.jpg',
      title: 'Beauty & Personal Care',
    ),
    Photo(
      assetName: 'images/home.jpg',
      title: 'Home Care & Fashion',
    ),
    Photo(
      assetName: 'images/nonveg.jpg',
      title: 'Non Veg',
    ),
    Photo(
      assetName: 'images/eggs.jpg',
      title: 'Dairy, Bakery & Eggs',
    ),
  ];

  static const double height = 366.0;
  String name = 'My Wishlist';
  int selectedPosition = 0;
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
    // TODO: implement build
    final Orientation orientation = MediaQuery.of(context).orientation;
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle =
        theme.textTheme.headline5.copyWith(color: Colors.black54);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    ShapeBorder shapeBorder;
    var deviceData = MediaQuery.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: Navigation_Drawer(new Auth()),
      bottomNavigationBar:
          Custom_AppBar().getButtomNavigation(context, firebaseUser),
      appBar: Custom_AppBar().getAppBar(context),
      body: new SingleChildScrollView(
        child: Container(
          child: new Column(children: <Widget>[
            Row(children: [
              SizedBox(
                  height: 150.0,
                  width: deviceData.size.width,
                  child: Carousel(
                    images: [
                      ExactAssetImage("images/masala.jpg"),
                      ExactAssetImage("images/spices.jpg"),
                      ExactAssetImage("images/brandlogo.png"),
                      ExactAssetImage("images/groceries.jpg"),
                      ExactAssetImage("images/masala3.jpeg"),
                      ExactAssetImage("images/masala4.jpeg")
                    ],
                  )),
            ]),
            Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _verticalD(),
                  new GestureDetector(
                    onTap: () {
                      /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Item_Screen('Best value Products')));*/
                    },
                    child: new Text(
                      'Best value',
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
                              builder: (context) =>
                                  Item_Screen('Top sellers')));
                    },
                    child: new Text(
                      'Top sellers',
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.black26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  _verticalD(),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Item_Screen('All Product')));
                        },
                        child: new Text(
                          'All',
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black26,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      _verticalD(),
                      IconButton(
                        icon: keyloch,
                        color: Colors.black26,
                      )
                    ],
                  )
                ]),
            new Container(
              height: 188.0,
              margin: EdgeInsets.only(left: 5.0),
              child:
                  ListView(scrollDirection: Axis.horizontal, children: <Widget>[
                SafeArea(
                  top: true,
                  bottom: true,
                  child: Container(
                    width: 270.0,

                    child: Card(
                      shape: shapeBorder,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 180.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: Image.asset(
                                    'images/grthre.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // description and share/explore buttons
                    // share, explore buttons
                  ),
                ),
                SafeArea(
                  top: true,
                  bottom: true,
                  child: Container(
                    width: 270.0,

                    child: Card(
                      shape: shapeBorder,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 180.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: Image.asset(
                                    'images/grtwo.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // description and share/explore buttons
                    // share, explore buttons
                  ),
                ),
                SafeArea(
                  top: true,
                  bottom: true,
                  child: Container(
                    width: 270.0,

                    child: Card(
                      shape: shapeBorder,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 180.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: Image.asset(
                                    'images/groceries.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // description and share/explore buttons
                    // share, explore buttons
                  ),
                ),
                SafeArea(
                  top: true,
                  bottom: true,
                  child: Container(
                    width: 270.0,

                    child: Card(
                      shape: shapeBorder,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 180.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                  child: Image.asset(
                                    'images/back.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    // description and share/explore buttons
                    // share, explore buttons
                  ),
                ),
              ]),
            ),
            Container(
              margin: EdgeInsets.only(top: 7.0),
              child: new Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _verticalD(),
                    new GestureDetector(
                      onTap: () {
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=> Item_Screen(toolbarname: 'Fruits & Vegetables',)));
                      },
                      child: new Text(
                        'Categories',
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
                                builder: (context) => PopularPage_Screen()));
                      },
                      child: new Text(
                        'Popular',
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black26,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    _verticalD(),
                    new Row(
                      children: <Widget>[
                        new GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => WhatsNew_Screen()));
                          },
                          child: new Text(
                            'Whats New',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black26,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
            Container(
              alignment: Alignment.topCenter,
              //height: 1000.0,
              child: FutureBuilder(
                  future: DataCollection().getCategoryList(),
                  builder: (_, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading...."),
                      );
                    } else {
                      return GridView.builder(
                          primary: true,
                          physics: ScrollPhysics(),
                          padding: const EdgeInsets.all(5.0),
                          shrinkWrap: true,
                          gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var d = snapshot.data;
                            //print(snapshot.data[index].documentID);
                            return GestureDetector(

                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Item_Screen(
                                            snapshot.data[index].documentID)));
                              },
                              child: Column(
                                children: <Widget>[
                                  WidgetFactory().getImageFromDatabase(context,
                                      d[index].data['categoryImageUrl']),
                                  Expanded(
                                    child:
                                        Text(snapshot.data[index].documentID),
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                  }),
            )
          ]),
        ),
      ),
    );
  }


  Icon keyloch = new Icon(
    Icons.arrow_forward,
    color: Colors.black26,
  );

  _verticalD() => Container(
        margin: EdgeInsets.only(left: 5.0, right: 0.0, top: 5.0, bottom: 0.0),
      );
}




