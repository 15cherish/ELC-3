import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(Login());
}
class Login extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<Login>{
  var email = TextEditingController();
  var pass = TextEditingController();
  var _pass = true;

  @override
  void initState(){
    super.initState();
    setState(() {
      check();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Login"),
      ),
      backgroundColor: Colors.grey,
      body:Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 16,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: EdgeInsets.all(16)),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(),
                      labelText: 'Email ID',
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: pass,
                    obscureText: _pass,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _pass
                              ? Icons.visibility_off : Icons.visibility,
                          color: Theme
                              .of(context)
                              .primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _pass = !_pass;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                ElevatedButton(
                    onPressed: (){
                      loader();
                      login();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Login",style: TextStyle(fontSize: 24),),
                    )
                ),
                Padding(padding: EdgeInsets.all(8)),
              ],
            ),
          ),
        ),
      ) ,
    );
  }
  void check(){
    if(FirebaseAuth.instance.currentUser!=null){
      print("user logged in already");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
    }
  }
  void login(){
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.toString(),
          password: pass.text.toString()
      );
    }on FirebaseAuthException catch (e){
      var text;
      if (e.code == 'user-not-found') {
        text = "User not Registered";
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        text = "Wrong Email/Password";
        print('Wrong password provided for that user.');
      } else {
        text = 'Unexpected Error! Try Later';
        print('Some other error- $e');
      }
      setState(() {
        pass.text = "";
      });
      Navigator.pop(context);
      final snackBar = SnackBar(content: Text(text));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    print("login complete------------------------------------");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);

  }
  Future<void> loader() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            width: MediaQuery.of(context).size.width*0.75,
            height: MediaQuery.of(context).size.height*0.75,
            child: Center(
              //heightFactor: MediaQuery.of(context).size.height*.75,
              widthFactor: MediaQuery.of(context).size.width*.75,
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}