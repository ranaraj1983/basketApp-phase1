import 'package:basketapp/Account_screen.dart';
import 'package:basketapp/CustomerOffer_Screen.dart';
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
import 'package:google_fonts/google_fonts.dart';
import 'package:mobx/mobx.dart';
import 'package:badges/badges.dart';

final cartCounter = Cart_Counter();

class Custom_AppBar {
  int selectedPosition = 0;

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

  Widget getCartListWidgetListView(BuildContext context) {
    print(cartCounter.cartList.length);
    return (
        cartCounter.cartList.length > 0 ?
        WidgetFactory().populateCartList(context) :
        WidgetFactory().emptyWidget()
    );
  }

  void addItemToCart(String itemId, String itemName, String imageUrl,
      String description, String quantity, String price, String itemUniqueId) {
    ObservableList<Product_Item> list = cartCounter.getCart();
    var prod = list.singleWhere((item) => item.itemName == itemName,
        orElse: () => null);
    prod == null ? _add(
        itemId,
        itemName,
        imageUrl,
        description,
        quantity,
        price,
        itemUniqueId) : _addToExistingObject(
        prod,
        itemId,
        itemName,
        imageUrl,
        description,
        quantity,
        price,
        itemUniqueId
    );
  }

  void _addToExistingObject(prod, String itemId, String itemName,
      String imageUrl,
      String description, String quantity, String price, String itemUniqueId) {
    //ObservableList<Product_Item> list = cartCounter.getCart();
    //var prod = list.singleWhere((item) => item.itemName == itemName, orElse: () => null);
    cartCounter.removeCartItemToBusket(itemName);
    print(quantity + " :: " + prod.quantity);
    quantity = (int.parse(quantity) + int.parse(prod.quantity)).toString();
    cartCounter.addCartItemToBusket(
        itemId,
        itemName,
        imageUrl,
        description,
        quantity,
        price,
        itemUniqueId);
    //prod.quantity  = quantity;
    print(quantity);

    //cartCounter.cartList(prod);
  }

  void _add(String itemId, String itemName, String imageUrl,
      String description, String quantity, String price, String itemUniqueId) {
    cartCounter.addCartItemToBusket(
        itemId,
        itemName,
        imageUrl,
        description,
        quantity,
        price,
        itemUniqueId
    );
  }

  void removeItemFromCart(String itemId) {
    //cartCounter.getTotal();
    print(cartCounter.getTotal);
    cartCounter.removeCartItemToBusket(itemId);
  }

  Widget getAppBar(BuildContext context) {
    return AppBar(
      //leading: new Icon(Icons.menu,color: Colors.yellowAccent,),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Go Mudi",
            style: GoogleFonts.lobster(
              textStyle: Theme.of(context).textTheme.headline5,
              fontSize: 40,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              color: Colors.yellowAccent,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(68.0),

        child: SizedBox(

          height: MediaQuery
              .of(context)
              .size
              .height / 15,
          width: MediaQuery
              .of(context)
              .size
              .width / 1.2,
          //padding: EdgeInsets.all(1.0),
          child: TextField(
            autofocus: false,
            onTap: () {
              showSearch(
                context: context,
                delegate: ItemSearchDelegate(),
              );
            },
            //controller: editingController,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.yellowAccent,
                //labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)
                    )
                )
            ),
          ),

        ),
      ),
      //backgroundColor: Colors.lime[400],
      actions: <Widget>[

        Observer(
            builder: (_) =>
                Stack(

                  children: <Widget>[
                    Badge(
                      elevation: 10,
                      toAnimate: false,
                      position: BadgePosition.topRight(top: -5, right: 10),
                      badgeContent: Text("${cartCounter.cartList.length}"),
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart,
                            color: Colors.yellow, size: 35),
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkout(),
                              ))
                        },
                      ),
                    ),

                  ],
                )

        ),
      ],
    );
  }

  void clearCart() {
    cartCounter.clearBusketCart();
  }


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
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerOffer_Screen(),
          ));
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

  Widget getBottomNavigation(BuildContext context, FirebaseUser firebaseUser) {
    return BottomNavigationBar(

      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.yellow),
          title: Text('Home', style: TextStyle(color: Colors.yellow,
              fontWeight: FontWeight.bold)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.card_giftcard, color: Colors.yellow),
          title: Text('Offer', style: TextStyle(
              color: Colors.yellow, fontWeight: FontWeight.bold)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_ind, color: Colors.yellow),
          title: Text('Profile', style: TextStyle(
              color: Colors.yellow, fontWeight: FontWeight.bold)),
        ),
      ],
      currentIndex: selectedPosition,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.indigo,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      onTap: (index) {
        selectedPosition = index;

        _navigateToPage(index, context, firebaseUser);
      },
    );
  }


  Future<List<Product_Item>> _getSearchItem(String text) {
    return DataCollection().getListOfProductItem();
  }
}

class ItemSearchDelegate extends SearchDelegate<Product_Item> {

  List<Product_Item> output = new List<Product_Item>();

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await DataCollection().getListOfProductItem();
          //print(output);
          close(context, null);
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,));
  }

  @override
  Widget buildResults(BuildContext context) {
    return null;
  }

  Widget _doSearch(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: DataCollection().getCategoryList(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return query.isEmpty ? Container() :
                Container(
                  child: FutureBuilder(
                    future: DataCollection().getSubCollectionWithSearchKey(
                        snapshot.data[index].documentID, query),
                    builder: (_, snp) {
                      if (snp.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snp.data.length,
                            itemBuilder: (_, ind) {
                              return !snp.data[ind].data['itemName']
                                  .toString()
                                  .toLowerCase()
                                  .contains(query.toLowerCase())
                                  ? Container()
                                  : Container(
                                child: WidgetFactory().getSearchListView(
                                    context, snapshot.data[index],
                                    snp.data[ind]),

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

  @override
  Widget buildSuggestions(BuildContext context) {
    print(query);
    return query.length > 3 ? _doSearch(context) : Text("Searching......");
  }


}
