import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';
import 'app.dart';

void main() {
  runApp(MaterialApp(home: Init()));
}
class Init extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<Init> {
  bool _initialized = false;
  bool _error = false;
  void initializeFlutterFire() async {
    Logo();
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // Show error message if initialization failed
    if (_error) {
      Logo();
    }
    if(_initialized) {
      if (FirebaseAuth.instance.currentUser == null) {
        return MyApp();
      } else {
        return Home();
      }
    }else{
      return Logo(); //Loader until FlutterFire is initialized
    }
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
      ),
    );
  }
}