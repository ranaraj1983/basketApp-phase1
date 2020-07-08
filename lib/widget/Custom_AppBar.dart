import 'package:basketapp/Account_screen.dart';
import 'package:basketapp/HomeScreen.dart';
import 'package:basketapp/checkout_screen.dart';
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:basketapp/widget/Cart_Counter.dart';
import 'package:basketapp/model/Product_Item.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:badges/badges.dart';

final cartCounter = Cart_Counter();

class Custom_AppBar {

  void addValueToState() {
    cartCounter.increment();
  }

  int getCartTotalPrice() {
    int price = 0;
    cartCounter.cartList.forEach((element) {
      price += int.parse(element.price);
    });

    return price;
  }

  ObservableList<Product_Item> getCartList() {
    return cartCounter.cartList;
  }

  Widget getCartListWidgetListView(Checkout checkout) {
    return ListView.builder(

      //scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: cartCounter.cartList.length,
        itemBuilder: (BuildContext context, int index) {
          int quan = int.parse(cartCounter.cartList[index].quantity);
          int price = int.parse(cartCounter.cartList[index].price);
          int total = quan * price;
          return Container(
            height: 150,

            //margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[

                Card(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10, bottom: 10, right: 10, top: 10),
                    margin: new EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Image.network(cartCounter.cartList[index]
                              .imageUrl,
                            fit: BoxFit.fitWidth, width: 100, height: 100,)
                        ),
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

                                  Text(" = " + price.toString() + ""),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    tooltip: "Delete Item",
                                    icon: Icon(
                                        Icons.delete_forever, color: Colors.red,
                                        size: 35),
                                    onPressed: () =>
                                    {
                                      print(cartCounter.cartList[index].itemId),
                                      Custom_AppBar().removeItemFromCart(cartCounter
                                          .cartList[index].itemUniqueId),
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

                 /* margin: new EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 4.0,

                  child: Row(

                    children: [
                      Column(
                        children: [
                          SizedBox(
                            child: Image.network(cartCounter.cartList[index]
                                .imageUrl,
                              fit: BoxFit.fitWidth, width: 100, height: 100,),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [



                                  Expanded(
                                    child: Text(cartCounter.cartList[index].itemName,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold)),
                                  ),

                            ],
                          ),
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
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                tooltip: "Delete Item",
                                icon: Icon(
                                    Icons.delete_forever, color: Colors.red,
                                    size: 35),
                                onPressed: () =>
                                {
                                  print(cartCounter.cartList[index].itemId),
                                  Custom_AppBar().removeItemFromCart(cartCounter
                                      .cartList[index].itemUniqueId),
                                },
                              ),
                            ],
                          ),
                        ],
                      ),


                    ],
                  ),*/
                ),


              ],


              // Divider(height: 15.0),

            ),
          );
        });
  }

  void addItemToCart(String itemId, String itemName, String imageUrl,
      String description, String quantity, String price, String itemUniqueId) {
    cartCounter.addCartItemToBusket(
        itemId,
        itemName,
        imageUrl,
        description,
        quantity,
        price,
        itemUniqueId);
  }

  void removeItemFromCart(String itemId) {
    cartCounter.removeCartItemToBusket(itemId);
    /* cartCounter.cartList.removeWhere((element) =>
    element.itemUniqueId == itemId);*/
    //cartCounter.removeCartItemFromBusket();
  }

  Widget getAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'images/goMudilogo.png',
            fit: BoxFit.contain,
            height: 32,
          ),

        ],

      ),
      backgroundColor: Colors.lime[400],
      actions: <Widget>[
        IconButton(
          tooltip: 'Search',
          icon: const Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: ItemSearchDelegate(),
            );
          },
        ),

        Observer(
            builder: (_) =>
                Stack(

                  children: <Widget>[
                    Badge(
                      elevation: 10,
                      toAnimate: false,
                      position: BadgePosition.topRight(top: -5, right: 20),
                      badgeContent: Text("${cartCounter.cartList.length}"),
                      child: IconButton(
                        icon: Icon(
                            Icons.shopping_cart, color: Colors.black, size: 35),
                        onPressed: () =>
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkout(),
                              ))
                        },
                      ),
                    ),
                    /* Positioned(
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart, color: Colors.black),
                        onPressed: () =>
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkout(),
                              ))
                        },
                      ),
                    ),*/
                    /* Positioned(

                      child: Container(
                        child: Text(
                          "${cartCounter.cartList.length}",
                          style: TextStyle(
                              fontSize: 30, backgroundColor: Colors.pink),
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16.0),
                                topRight: Radius.circular(16.0)
                            )
                        ),
                      ),

                    ),*/
                  ],
                )

        ),
      ],
    );
  }

  void clearCart() {
    cartCounter.clearBusketCart();
  }

  int selectedPosition = 0;

  void _navigateToPage(int index, BuildContext context,
      FirebaseUser firebaseUser) {
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => Home_screen(),
      )
      );
    } else if (index == 1) {
      print("inside offer");
      var categoryList = DataCollection().getCategories();
      categoryList.then((value) {
        value.documents.forEach((element) {
          //element.documentID;
          print(element.documentID);
        });
      });
    } else if (index == 2) {
      firebaseUser == null ? WidgetFactory()
          .logInDialog(context) : Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            //String user;
            //return
            return firebaseUser == null ? WidgetFactory()
                .logInDialog(context) : Account_Screen(new Auth());
          }
      )
      );
    }
  }

  Widget getButtomNavigation(BuildContext context, FirebaseUser firebaseUser) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard),
          title: Text('Offer'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_ind),
          title: Text('Profile'),
        ),
      ],
      currentIndex: selectedPosition,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.grey.shade100,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        selectedPosition = index;

        _navigateToPage(index, context, firebaseUser);
      },
    );
  }

}

class ItemSearchDelegate extends SearchDelegate<Product_Item> {

  List<Product_Item> output = new List<Product_Item>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = "";
    })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: () async {
      await DataCollection().getListOfProductItem();
      //print(output);
      close(context, null);
    }, icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: DataCollection().getCategoryList(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Searching");
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return query.isEmpty ? Container() :
                Container(
                  child: FutureBuilder(
                    future: DataCollection().getSubCollectionWithSearchKey(
                        snapshot.data[index].documentID, query),
                    builder: (_, snp) {
                      if (snp.connectionState == ConnectionState.waiting) {
                        return Text("");
                      } else {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snp.data.length,
                            itemBuilder: (_, ind) {
                              return !snp.data[ind].data['itemName']
                                  .toString()
                                  .toLowerCase()
                                  .
                              contains(query.toLowerCase())
                                  ? Text("")
                                  : Container(
                                child: WidgetFactory().getSearchListView(
                                    context, snapshot.data[index],
                                    snp.data[ind]),
                                /*title: Text(snp.data[ind].data['itemName'] + " :: " + snapshot.data[index].documentID),
                                        onTap: (){

                                        },*/
                              );
                            }
                        );
                      }
                    },
                  ),
                );
              },

            );
          }
        },
      ),
    );
  }


}
