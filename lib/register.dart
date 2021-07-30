import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home.dart';

void main() {
  runApp(Register());
}
class Register extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => RegisterState();
}

class RegisterState extends State<Register>{
  var email = TextEditingController();
  var pass = TextEditingController();
  var name = TextEditingController();
  var _pass = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar:  AppBar(
        title: Text("Register"),
      ),
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
                    controller: name,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border:OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
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
                      register();
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text("Register",style: TextStyle(fontSize: 24),),
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
  Future<void> register()  async {
    var textLog;
    UserCredential info;
    if((email.text.toString().length < 8) || (pass.toString().length < 8) || (name.toString().length < 3) ){
      textLog = "Enter a Valid Input";
      Navigator.pop(context);
      print(email.text.toString());
      print(pass.text.toString());
      print(name.text.toString());
      final snackBar = SnackBar(content: Text(textLog));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    try {
      info = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text.toString(),
        password: pass.text.toString(),
    );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        textLog = "Password is too weak";
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        textLog = "User Already Registered";
        print('The account already exists for that email.');
      }else{
        textLog = "Unexpected Error! Try Later";
        print('Unexpected Error- $e');
      }
      Navigator.pop(context);
      final snackBar = SnackBar(content: Text(textLog));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    User user = info.user;
    user.updateProfile(displayName: name.text.toString());
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