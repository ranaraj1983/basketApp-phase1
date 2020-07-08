import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
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

class DataCollection {
  final firestoreInstance = Firestore.instance;

  Future getCategoryList() async {
    QuerySnapshot qs =
        await firestoreInstance.collection("categories").getDocuments();
    return qs.documents;
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
        .collection("User/${userId}/orders")
        .document(masterOrderId)
        .collection(masterOrderId)
        .getDocuments();
    return qs;
  }

  Future getOrderHistoryList() async {
    String userId = await Auth().getCurrentUserId();

    Order order;

    QuerySnapshot qs = await firestoreInstance
        .collection("User/${userId}/orders")
        .getDocuments();

    return qs;

  }

  void addCustomerCartToDatabase(ObservableList<Product_Item> cartList,
      int totalAmount) async {
    String userId = await Auth().getCurrentUserId();
    //List<Cart_List> listOfOrder = new List<Cart_List>();

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
      'totalAmount': totalAmount,
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
              "totoalAmount": "2000"
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

  void updateUserProfile(String userId) {


  }

  void createUserTable(String uid, String phone) {
    firestoreInstance
        .collection("User").document(uid).setData(
        {
          'mobileNumber': phone,

        }
    );
  }

  Future getUserDetails() async {
    String userId = await Auth().getCurrentUserId();
    DocumentSnapshot user = await firestoreInstance
        .collection("User")
        .document(userId).get();
    return user.data;
  }

  void addAddress(FirebaseUser user, String displayName, String street,
      String city, String district, String mobilenumber, String state,
      String pincode) {
    firestoreInstance
        .collection("User").document(user.uid).setData(
        {
          'mobileNumber': mobilenumber,
          'displayName': displayName,
          'street': street,
          'city': city,
          'district': district,
          'state': state,
          'pincode': pincode
        }
    );
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
}