import 'register.dart';
import 'login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("ManageCore"),
      ),
      backgroundColor: Colors.grey,
      body:Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(16)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Login",style: TextStyle(fontSize: 28),),
                  )
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 18)),
              ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text("Register",style: TextStyle(fontSize: 28),),
                  )
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(8)),
        ],
      ),
    );
  }
}
