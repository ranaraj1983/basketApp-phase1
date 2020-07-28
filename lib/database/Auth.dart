import 'dart:async';
import 'package:basketapp/database/DataCollection.dart';
import 'package:basketapp/model/Order.dart';
import 'package:basketapp/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer2/mailer.dart';

abstract class BaseAuth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<FirebaseUser> signupWithFacebook(BuildContext context);

  Future<void> resetPassword(String password);
}



class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> signupWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
    FirebaseUser user;

    try {
      await _googleSignIn.signIn();
      print(_googleSignIn.currentUser.displayName);
      final GoogleSignInAccount googleUser = await _googleSignIn.currentUser;
      //Future<GoogleSignInAccount> gu =  _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _firebaseAuth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);
    } catch (error) {
      print(error);
    }

    return user;
  }

  Future<FirebaseUser> signupWithFacebook(BuildContext context) async {
    final FacebookLogin facebookSignIn = new FacebookLogin();
    try {
      var user = await facebookSignIn.logIn(['email', 'public_profile']);
      print(user.accessToken);
    } catch (error) {
      print(error);
    }
/*    await facebookSignIn.logIn(['email', 'public_profile']).then((result) async {
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          await _firebaseAuth
              .signInWithCredential(FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token))
              .then((user) {
            Navigator.of(context).pushReplacementNamed("/home");
            print("facebook signedin user :: ${user.toString()}");
          }).catchError((onError) {
            print(onError);
          });
          break;
        case FacebookLoginStatus.error:
          print("login error");
          break;
        case FacebookLoginStatus.cancelledByUser:
          print("cancel by user");
      }
    }).catchError((onError) {
      print(onError);
    });*/
  }

  Future<void> resetPassword(String password) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    print(password);
    user.updatePassword(password);
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    //_firebaseAuth.sendSignInWithEmailLink(email: null, url: null, handleCodeInApp: null, iOSBundleID: null, androidPackageName: null, androidInstallIfNotAvailable: null, androidMinimumVersion: null)
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


  Future<String> registerUser(String email, String password, String firstName,
      String lastName, String phone) async {
/*    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;

    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = firstName + " " + lastName;
    //userUpdateInfo.

    await user.updateProfile(userUpdateInfo);
    await user.reload();
    user = await _firebaseAuth.currentUser();
    DataCollection().createUserTable(
        user.uid, phone, email, (firstName + " " + lastName));*/

    var option = SmtpOptions()
      //..hostName = "mocha3016.mochahost.com"
      ..username = "support@gomudi.com"
      //..port = 995
      ..password = "Go@Shipco123";

    final smtpServer = SmtpServer("mocha3016.mochahost.com");
    var emailTransport = new SmtpTransport(option);

    // Create our mail/envelope.
    var envelope = new Envelope()
      ..from = 'support@gomudi.com'
      ..recipients.add(email)
      ..bccRecipients.add('ranaraj1983@gmail.com')
      ..subject = 'Testing the Dart Mailer library'
      //..attachments.add(new Attachment(file: new File('path/to/file')))
      ..text = 'This is a cool email message. Whats up?'
      ..html = '<h1>Test</h1><p>Hey!</p>';

    // Email it.
    emailTransport
        .send(envelope)
        .then((envelope) => {print('Email sent!')})
        .catchError((e) => print('Error occurred: $e'));

/*    final message = Message()
      ..from = Address("support@gomudi.com", 'Mudi')
      ..recipients.add(email)
      //..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      ..bccRecipients.add(Address('ranaraj1983@gmail.com'))
      ..subject = 'Test Dart Mailer library :: 😀 :: ${DateTime.now()}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }*/
    //print(user.displayName);
  }
}

