Plan to apply
===============
animated_text_kit 2.2.0
======================
email
===============
support@gomudi.com
Go@Shipco123
=================
# basketapp

A new Flutter application.

command to run .g file

flutter pub run build_runner build

https://ptyagicodecamp.github.io/loading-image-from-firebase-storage-in-flutter-app-android-ios-web.html
https://github.com/ptyagicodecamp/flutter_cookbook/tree/widgets/flutter_widgets

https://github.com/mayuriruparel/flutter_demo_apps




keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

flutter clean
go topubspec.yaml and change build version
flutter build appbundle
flutter build apk --split-per-abi

/Users/dasinfosolutions/key.jks

Known Issue:-
1)CartSession or refresh null

keytool -list -v -keystore /Users/dasinfosolutions/key.jks

Keystore type: PKCS12
Keystore provider: SUN

Your keystore contains 1 entry

Alias name: key
Creation date: 02-Jul-2020
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: CN=Rana Das, OU=Das Info Solutions, O=Das Info Solutions, L=Santipur, ST=West Bengal, C=91
Issuer: CN=Rana Das, OU=Das Info Solutions, O=Das Info Solutions, L=Santipur, ST=West Bengal, C=91
Serial number: 6b9c25a6
Valid from: Thu Jul 02 13:00:12 IST 2020 until: Mon Nov 18 13:00:12 IST 2047
Certificate fingerprints:
	 SHA1: 4D:92:63:15:2D:30:7E:36:44:43:DA:34:ED:A8:90:5F:67:64:D2:F6
	 SHA256: 18:1F:21:31:43:4D:FA:A6:58:C5:0E:0D:E1:37:56:20:F4:94:8D:D2:32:E9:F9:41:C5:8F:D0:B8:25:67:BB:7C
Signature algorithm name: SHA256withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 3

Extensions:

#1: ObjectId: 2.5.29.14 Criticality=false
SubjectKeyIdentifier [
KeyIdentifier [
0000: 29 2D 53 17 D2 19 2E F6   87 28 DF 23 59 8C 1E 8A  )-S......(.#Y...
0010: 76 B1 5C C4                                        v.\.
]
]



*******************************************
*******************************************


keytool -list -v \
-alias key -keystore /Users/dasinfosolutions/key.jks

facebook
===========
keytool -exportcert -alias key -keystore /Users/dasinfosolutions/ | openssl sha1 -binary | openssl base64
nQvNkpDsLvKow0qPyod3lLptNh0=
TZJjFS0wfjZEQ9o07aiQX2dk0vY=



keytool -exportcert -alias YOUR_RELEASE_KEY_ALIAS -keystore YOUR_RELEASE_KEY_PATH | openssl sha1 -binary | openssl base64
=====================

4D:92:63:15:2D:30:7E:36:44:43:DA:34:ED:A8:90:5F:67:64:D2:F6

keytool -exportcert -alias key -keystore /Users/dasinfosolutions/key.jks | openssl sha1 -binary | openssl base64



Debug key for google
=========================
keytool -list -v -keystore ~/.android/debug.keystore
*****************  WARNING WARNING WARNING  *****************

Keystore type: JKS
Keystore provider: SUN

Your keystore contains 1 entry

Alias name: androiddebugkey
Creation date: 02-Jul-2020
Entry type: PrivateKeyEntry
Certificate chain length: 1
Certificate[1]:
Owner: C=US, O=Android, CN=Android Debug
Issuer: C=US, O=Android, CN=Android Debug
Serial number: 1
Valid from: Thu Jul 02 00:23:41 IST 2020 until: Sat Jun 25 00:23:41 IST 2050
Certificate fingerprints:
	 SHA1: DA:8F:29:AE:60:11:7F:FD:93:6C:91:4D:29:F5:62:4A:84:48:66:51
	 SHA256: 2D:87:C4:7D:95:8D:DD:3B:DA:78:55:EB:BA:06:6C:7E:7A:0F:A5:1F:8E:A7:78:D1:31:6A:D4:C0:A1:95:A4:EC
Signature algorithm name: SHA1withRSA
Subject Public Key Algorithm: 2048-bit RSA key
Version: 1


*******************************************
*******************************************


