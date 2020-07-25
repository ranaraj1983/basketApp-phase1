import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:basketapp/widget/Custom_AppBar.dart';
import 'package:basketapp/widget/WidgetFactory.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as path;
import 'package:basketapp/database/Auth.dart';
import 'package:basketapp/model/Order.dart';
import 'package:basketapp/model/Product_Item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

enum OderStatus { PLACED, CANCEL, DELIVERED, WISHLIST }
enum PaymentStatus { COD, BANK, OFFER }

class DataCollection {
  final firestoreInstance = Firestore.instance;

  //Firestore.instance.se

  Future getCategoryList() async {
    QuerySnapshot qs =
        await firestoreInstance.collection("categories").getDocuments();
    return qs.documents;
  }

  Future getPopularProductList() {
    //TODO need need implement
    getListOfProductItem();
  }

  Future getNewlyAddedProduct() async {
    QuerySnapshot qs = await firestoreInstance
        .collection("categories")
        .orderBy("orderDate", descending: true)
        .getDocuments();
    return qs.documents;
  }

  addCustomItem(String itemName, String quantity, String unit) async {
    String userId = await Auth().getCurrentUserId();
    firestoreInstance
        .collection("User/${userId}/customOrder")
        .document()
        .setData({
      'itemName': itemName,
      'quantity': quantity,
      'unit': unit
    }).catchError((onError) {
      return onError.toString();
    }).then((value) {
      return null;
    }).whenComplete(() {
      return null;
    });
  }

  void getDataFromDatabase() {
    String itemId;
    String itemName;
    String imageUrl;
    List itemList;

    firestoreInstance
        .collection("categories")
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        itemList.add(result);
        itemName = result.data['itemName'];
        imageUrl = result.data['imageUrl'];
        itemId = result.data['itemId'];

        print(result.data);
        return itemList;
      });
    });
    debugPrint("value from database : " + itemList.length.toString());
    print("value from database : " +
        itemName +
        " :: " +
        itemId +
        " :: " +
        imageUrl);
    debugPrint("value from database : " +
        itemName +
        " :: " +
        itemId +
        " :: " +
        imageUrl);
  }

  //var output = new List<String>();
  Future getListOfProductItem() async {
    QuerySnapshot qs =
        await firestoreInstance.collection("categories").getDocuments();
    return qs.documents;
  }

  Future getSubCollectionOfOrder(String masterOrderId) async {
    String userId = await Auth().getCurrentUserId();

    QuerySnapshot qs = await firestoreInstance
        .collection("Order/${masterOrderId}/${masterOrderId}")
        .getDocuments();

/*    QuerySnapshot qs = await firestoreInstance
        .collection("User/${userId}/orders")
        .document(masterOrderId)
        .collection(masterOrderId)
        .getDocuments();*/
    return qs;
  }

  Future getOrderHistoryList() async {
    String userId = await Auth().getCurrentUserId();

    QuerySnapshot qs = await firestoreInstance
        .collection("Order")
        .orderBy("orderDate", descending: true)
        .getDocuments();

/*    QuerySnapshot qs = await firestoreInstance
        .collection("User/${userId}/orders")
        .orderBy("orderDate", descending: true)
        .getDocuments();*/

    return qs;
  }

  Future<void> addOrder(ObservableList<Product_Item> cartList, int totalAmount,
      bool courierChargeApplied, int totalRedeemAmount) async {
    int courierCharge = 0;
    //int amount = totalAmount;
    courierChargeApplied ? courierCharge = 50 : courierCharge = 0;
    Random random = new Random();
    int randomNumber = random.nextInt(100000);

    FirebaseUser user = await Auth().getCurrentUser();
    String masterOrderId = "#GMDI" + randomNumber.toString();
    Placemark place = await WidgetFactory().getAddressFromLatLng();
    //await _getUserAddress(user.uid).;
    //address.
    CollectionReference masterOrderSnapshot = firestoreInstance
        .collection("Order")
        .document(masterOrderId)
        .collection(masterOrderId);

    await firestoreInstance
        .collection("Order")
        .document(masterOrderId)
        .setData({
      'orderId': masterOrderId,
      'amount': totalAmount,
      'totalAmount': totalAmount + courierCharge,
      "courierCharge": courierCharge,
      'orderDate': new DateTime.now(),
      "userId": user.uid,
      "orderStatus": "PLACED",
      "paymentOption": "COD",
      "customerName": user.displayName,
      "mobileNumber": user.phoneNumber,
      "redeemAmount": totalRedeemAmount
      //"address" :
    });

    cartList.forEach((element) async {
      String orderId = "#GMDI" + new Random().toString();
      try {
        await masterOrderSnapshot.document(element.itemName).setData(({
          'itemId': element.itemId,
          'itemName': element.itemName,
          'imageUrl': element.imageUrl,
          'description': element.description,
          'quantity': element.quantity,
          'price': element.price,
          'orderId': orderId,
          "totalAmount": totalAmount
        }));
      } catch (error) {
        debugPrint(error.toString());
      }
    });
  }

  void addCustomerCartToDatabase(ObservableList<Product_Item> cartList,
      int totalAmount, bool courierChargeApplied) async {
    String userId = await Auth().getCurrentUserId();
    //List<Cart_List> listOfOrder = new List<Cart_List>();
    int courierCharge = 0;
    //int amount = totalAmount;
    courierChargeApplied ? courierCharge = 50 : courierCharge = 0;
    //courierChargeApplied ? totalAmount += 50 : totalAmount = totalAmount;

    Random random = new Random();
    int randomNumber = random.nextInt(100000);

    String masterOrderId = "#GMDI" + randomNumber.toString();

    CollectionReference masterOrderSnapshot = firestoreInstance
        .collection("User")
        .document(userId)
        .collection("orders")
        .document(masterOrderId)
        .collection(masterOrderId);

    firestoreInstance
        .collection("User")
        .document(userId)
        .collection("orders")
        .document(masterOrderId)
        .setData({
      'orderId': masterOrderId,
      'amount': totalAmount,
      'totalAmount': totalAmount + courierCharge,
      "courierCharge": courierCharge,
      'orderDate': new DateTime.now()
    });

    cartList.forEach((element) {
      String orderId = "#GMDI" + new Random().toString();
      try {
        masterOrderSnapshot.document(element.itemName).setData(({
          'itemId': element.itemId,
          'itemName': element.itemName,
          'imageUrl': element.imageUrl,
          'description': element.description,
          'quantity': element.quantity,
          'price': element.price,
          'orderId': orderId,
          "timestamp": new DateTime.now(),
          //"location":
          "orderStatus": "PLACED",
          "paymentOption": "COD",

          "totalAmount": totalAmount
        }));
      } catch (error) {
        debugPrint(error.toString());
      }
    });
  }

  Future<Widget> getImageFromStorage(BuildContext context,
      String imageUrl, double height, double width) async {
    return await _getImageFromStorage(imageUrl, height, width);
  }

  Future getSubCollection(String documentId) async {
    QuerySnapshot qs = await firestoreInstance
        .collection("categories")
        .document(documentId)
        .collection("item")
        .getDocuments();
    return qs.documents;
  }

  Future getSubCollectionWithSearchKey(String documentId,
      String searchKey) async {
    QuerySnapshot qs = await firestoreInstance
        .collection("categories")
        .document(documentId)
        .collection("item")
    //.where("itemName", searchKey)
        .getDocuments();


    return qs.documents;
  }

  Future getItemByCategories() async {
    QuerySnapshot qs =
    await firestoreInstance.collection("categories").getDocuments();

    return qs.documents;
  }

  Future getCategories() async {
    return await firestoreInstance.collection("categories").getDocuments();
  }

  Future<Widget> _getImageFromStorage(String imageUrl, double height,
      double width) async {
    CachedNetworkImage m;
    StorageReference storageReference = await FirebaseStorage.instance
        .getReferenceFromUrl(imageUrl);

    return await storageReference.getDownloadURL().then((value) {
      return m = CachedNetworkImage(
        height: height,
        width: width,
        imageUrl: value.toString(),
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => Icon(Icons.error),
      );

    });
  }

  void addCategoryToDB(
      String categoryName, String categoryId, String categoryImageUrl) async {
    try {
      await firestoreInstance
          .collection("categories")
          .document(categoryName)
          .setData({
        'categoryId': categoryId,
        'categoryName': categoryName,
        'categoryImageUrl': categoryImageUrl
      });
      print("inside add category 2 " + categoryName);
    } catch (er) {
      print(er);
    }
  }


  void addProductToDB(
      String itemName,
      String itemId,
      String description,
      String price,
      String quantity,
      String stock,
      String categoryName,
      String brand,
      String imageUrl,
      String unit,
      String offer) async {
    try {
      print("inside add product");

      await firestoreInstance
          .collection("categories")
          .document(categoryName)
          .collection("item")
          .document(itemName)
          .setData({
        'itemName': itemName,
        'itemId': itemId,
        'categoryName': categoryName,
        'quantity': quantity,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'brand': brand,
        'stock': stock,
        'offer': offer,
        'unit': unit
      });
      print("inside add category 2");
    } catch (er) {
      print(er);
    }
  }

  Future uploadImageToStorageAndCategoryImge(BuildContext context, File file,
      GlobalKey<ScaffoldState> _scaffoldKey, String categoryId) async {
    String fileName = path.basename(file.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(file);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    _updateCategoryImageUrl(categoryId, url);
    //Auth().updateProfileImage(url);
    //StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    /*_scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('Profile Picture Uploaded')));*/
  }

  Future uploadImageToStorageAndProductImge(BuildContext context,
      File file,
      GlobalKey<ScaffoldState> _scaffoldKey,
      String categoryName,
      String productName) async {
    String fileName = path.basename(file.path);
    StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child(
        "/category/$categoryName/item/" + fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(file);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    return url;
    //_updateProductImageUrl(categoryName, url, productName);
    //Auth().updateProfileImage(url);
    //StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    /*_scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('Profile Picture Uploaded')));*/
  }

  Future uploadImageToStorageAndProfileImge(BuildContext context, File file,
      GlobalKey<ScaffoldState> _scaffoldKey) async {
    String fileName = path.basename(file.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(file);
    var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = dowurl.toString();
    Auth().updateProfileImage(url);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

/*    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text('Profile Picture Uploaded')));*/
  }

  void updateUserProfile(String userId) {}

  Future getUserDetails() async {
    String userId = await Auth().getCurrentUserId();
    DocumentSnapshot user =
        await firestoreInstance.collection("User").document(userId).get();
    return user.data;
  }

  void createUserTable(String uid, String phone, email, displayName) async {
    Placemark place = await WidgetFactory().getAddressFromLatLng();
    addAddress(
        uid,
        displayName,
        place.name,
        place.locality,
        place.subAdministrativeArea,
        phone,
        place.administrativeArea,
        place.postalCode,
        email,
        place.country);

    /*await firestoreInstance
        .collection("User").document(uid).setData(
        {
          'mobileNumber': phone,
          "email": email,
          "displayName": displayName,
          "street": place.name,
          "city": place.locality,
          "pin": place.postalCode,
          "district": place.subAdministrativeArea,
          "state": place.administrativeArea,
          "country": place.country
          // "dis"
        }
    );*/
  }

  void addAddress(
      String userId,
      String displayName,
      String street,
      String city,
      String district,
      String mobileNumber,
      String state,
      String pincode,
      String email,
      String country) async {
    await firestoreInstance.collection("User").document(userId).setData({
      'mobileNumber': mobileNumber,
      'displayName': displayName,
      "email": email,
      'street': street,
      'city': city,
      'district': district,
      'state': state,
      "country": country,
      'pin': pincode
    });
  }

  void _updateProductImageUrl(String url, String categoryName,
      String itemName) {
    firestoreInstance
        .collection("categories")
        .document(categoryName)
        .collection("item")
        .document(itemName).setData(
        {
          'imageUrl': url,

        }
    );
  }

  void _updateCategoryImageUrl(String url, String categoryName) {
    firestoreInstance
        .collection("categories").document(categoryName).setData(
        {
          'categoryImageUrl': url,

        }
    );
  }

  void cancelCustomerOrder(itemData) async {
    String userId = await Auth().getCurrentUserId();
  }

  Future _getUserAddress(String uid) async {
    return await firestoreInstance.collection("User").document(uid).get();
  }

  void addOfferToCustomrWalet(int offerPrice) async {
    String userId = await Auth().getCurrentUserId();
    String walletId = "#GMOFF" + Random().nextInt(100000).toString();
    firestoreInstance
        .collection("User")
        .document(userId)
        .collection("Wallet")
        .document(walletId)
        .setData({
      'offerPrice': offerPrice,
      'date': new DateTime.now(),
      'status': "NEW",
      "type": "CASH",
      "id": walletId,
    });
  }

  Future getCustomerOfferList() async {
    String userId = await Auth().getCurrentUserId();
    return await firestoreInstance
        .collection("User/${userId}/Wallet/")
        .orderBy("date", descending: true)
        .getDocuments();
  }

  updateWalletTable(ObservableMap redeemMap) async {
    String userId = await Auth().getCurrentUserId();
    print(userId);
    redeemMap.forEach((key, value) {
      firestoreInstance
          .collection("User/${userId}/Wallet")
          .document(key)
          .setData({
        'status': "REDEEMED",
      }, merge: true).then((value) => {
                Custom_AppBar().clearRedeemAmount(),
              });
    });
    print(userId);
  }
}