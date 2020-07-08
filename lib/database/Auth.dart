import 'dart:async';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/model/Order.dart';
import 'package:basketapp/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<FirebaseUser>  signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}



class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signIn(String email, String password)  async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    //String userId = user.uid;
    return user;
  }
  void handleError(e) {
    print(e);
  }
  User _useValue(val){
    User u = new User(
      uid: val.uid,
      email: val.email,
      displayName: val.displayName,
      photoUrl: val.photoUrl,
    );

    return u;

    //print("this is my user value: " + val.email);
  }

  Future<FirebaseUser> getCurrentUserFuture() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user != null ? user : null;
    //return await _firebaseAuth.currentUser();
  }

  Future<String> getCurrentUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    print(user);
    return user.uid;
    //return await _firebaseAuth.currentUser();
  }

  User getUser(email, password) {
    Future<FirebaseUser> user = signIn(email, password);
    new Timer(new Duration(milliseconds: 5), () {
      user.then((usr) {
        return _useValue(usr);
      }, onError: (e) {
        handleError(e);
      });
    });
    return null;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;

    return user.uid;
  }

  List<Order> getOrderList() {}

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  void updateUserProfile() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    String name = "Rana Das";
    String url =
        "gs://gomodi-ee0d7.appspot.com/users/Screenshot 2020-05-21 at 00.04.18.png";
    userUpdateInfo.displayName = name;
    //userUpdateInfo.photoUrl = url;

    user.updateProfile(userUpdateInfo);
  }

  void changeProfileImage() {}

  void updateDisplayName(String name) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await user.updateProfile(userUpdateInfo);
    await user.reload();
    user = await _firebaseAuth.currentUser();
    print(user.displayName);
  }

  void updateProfileImage(String imageUrl) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.photoUrl = imageUrl;
    await user.updateProfile(userUpdateInfo);
    await user.reload();
    user = await _firebaseAuth.currentUser();
    // user.updateProfile(userUpdateInfo);
  }

  void updatePassword() {}

  Future<String> registerUser(String email, String password, String firstName,
      String lastName, String phone) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = firstName + " " + lastName;

    await user.updateProfile(userUpdateInfo);
    await user.reload();
    user = await _firebaseAuth.currentUser();
    DataCollection().createUserTable(user.uid, phone);
    print(user.displayName);
  }
}

