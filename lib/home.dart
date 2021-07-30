import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'history.dart';
import 'main.dart';
import 'transact.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var totalIncome = 0,monthIncome,monthExpend;
var today = new DateTime.now();
var month =DateFormat('MMM').format(today);
var year = DateTime.now().year;
var userName= "NUll";
void main() {
  runApp(Home());
}
class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home>{

  @override
  void initState(){
    super.initState();
    total().then((value){
      setState(() {
        totalIncome;
        monthIncome;
        monthExpend;
        userName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar:  AppBar(
        title: Text('Hi $userName'),
      ),
      body:Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 16,
                    child: Column(
                      children: [
                        //Padding(padding: EdgeInsets.all(16)),
                        Padding(padding: EdgeInsets.all(8),child: Text('Total Income'),),
                        Padding(padding: EdgeInsets.all(8),child: Text(totalIncome.toString()),)
                      ],
                    ),
                  ),
                  Card(
                    elevation: 16,
                    child: Column(
                      children: [
                        //Padding(padding: EdgeInsets.all(16)),
                        Padding(padding: EdgeInsets.all(8),child: Text("Month's Income"),),
                        Padding(padding: EdgeInsets.all(8),child: Text(monthIncome.toString()),)
                      ],
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(8)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 16,
                    child: Column(
                      children: [
                        //Padding(padding: EdgeInsets.all(16)),
                        Padding(padding: EdgeInsets.all(8),child: Text("Month's Expense"),),
                        Padding(padding: EdgeInsets.all(8),child: Text(monthExpend.toString()),)
                      ],
                    ),
                  ),
                  Card(
                    elevation: 16,
                    child: Column(
                      children: [
                        //Padding(padding: EdgeInsets.all(16)),
                        Padding(padding: EdgeInsets.all(8),child: Text("Remaining Allowance"),),
                        Padding(padding: EdgeInsets.all(8),child: Text((monthIncome-monthExpend).toString()),),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(MediaQuery.of(context).size.height*.23)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddData()));
                    },
                    child: Padding(padding: EdgeInsets.all(8),child: Text("Add Income/Expense"),),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 8)),
                  ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>History()));
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("View History"),
                      ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: (){
                    loader();
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Init()), (Route<dynamic> route) => false);
                  },
                  child: Padding(padding: EdgeInsets.all(8),child: Text("Logout"),),
                ),
              )
            ],
          ),
        ),
      ) ,
    );
  }
  Future<void> total() async {
    try{
      await FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser.email).get()
        .then((callback) async {
          totalIncome = callback.data()['total_income'];
          monthIncome = callback.data()['${month}Income'];
          monthExpend = callback.data()['${month}Expend'];
        }
      );
      userName = FirebaseAuth.instance.currentUser.displayName;
    } on FirebaseException catch (e){
     print(e);
     return;
    }catch (e){
      print(e);
      return;
    }
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
