# basketapp

A new Flutter application.

command to run .g file

flutter pub run build_runner build

https://ptyagicodecamp.github.io/loading-image-from-firebase-storage-in-flutter-app-android-ios-web.html
https://github.com/ptyagicodecamp/flutter_cookbook/tree/widgets/flutter_widgets

https://github.com/mayuriruparel/flutter_demo_apps


service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}

keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
fuller clean
flutter build appbundle
flutter build apk --split-per-abi

/Users/dasinfosolutions/key.jks

Known Issue:-
1)CartSession or refresh null





keytool -exportcert -alias key -keystore /Users/dasinfosolutions/key.jks | openssl sha1 -binary | openssl base64



