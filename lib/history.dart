import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(History());
}
class History extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => HistoryState();
}

class HistoryState extends State<History>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("History Page"),
          Info(),
        ],
      ),
    );
  }
  Widget details() {

      FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser.email)
          .collection('logs').orderBy('Date',descending: true).get()
          .then((QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach((doc) {
              return Card(child: Column(
                children: [
                  Padding(padding: EdgeInsets.all(16)),
                  Padding(padding: EdgeInsets.all(8),child: Text('Amount:- ${doc["Amount"]}'),)
                ],
              ),);
        });
      });
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
class Info extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child:StreamBuilder(
          stream: FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser.email)
              .collection('logs').orderBy('Date',descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return CircularProgressIndicator();
            }
            return ListView(
              scrollDirection: Axis.horizontal,
              children: snapshot.data.docs.map((document){
                return ReportCard(
                  title: document['Amount'].toString(),
                  value: document['Description'],
                );
              }).toList(),
            );
          }),
    );
  }
}
class ReportCard extends StatelessWidget{
  final String title;
  final String value;
  ReportCard({
    this.value,
    this.title,});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 206,
      child :Card(
        margin: EdgeInsets.all(8),
        color: Colors.orange,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 8,),
                  Text(this.title),
                ],
              ),
              SizedBox(height: 12,),
              Text(this.value),
              //Text(this.unit,style: GoogleFonts.abel(fontSize: 20),),
            ],
          ),
        ),
      ),
    );
  }

}