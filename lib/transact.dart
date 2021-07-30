import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var amount = TextEditingController();
var description = TextEditingController();
var today = new DateTime.now();
var month =DateFormat('MMM').format(today);

void main() {
  runApp(AddData());
}
class AddData extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AddDataState();
}

class AddDataState extends State<AddData>{

  @override
  void initState(){
    super.initState();
    amount.text="";
    description.text="";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Transaction'),
      ),
      backgroundColor: Colors.grey,
      body: Center(
        child: SingleChildScrollView(
          child:Card(
            elevation: 16,
            child: Column(
              children: [
                Padding(padding: EdgeInsets.all(16)),
                TextField(
                  controller: amount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border:OutlineInputBorder(),
                    labelText: 'Amount(+/-)',
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                TextField(
                  controller: description,
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 8,
                  decoration: InputDecoration(
                    border:OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                Padding(padding: EdgeInsets.all(8)),
                ElevatedButton(
                    onPressed: (){
                      loader();
                      add();
                    },
                    child: Text("Submit")
                ),
                Padding(padding: EdgeInsets.all(16)),
              ],
            ),
          )
        ),
      )
    );
  }
  Future<void> add() async {
    var info, monthIncome, monthExpend, totalIncome;
    if (amount.text.isEmpty || int.parse(amount.text) == 0) {
      info = "Enter some Value";
    } else {
      try {
        await FirebaseFirestore.instance.collection('User').doc(
            FirebaseAuth.instance.currentUser.email)
            .collection("logs").add({
          'Date': today,
          'Amount': amount.text.toString(),
          'Description': description.text.toString(),
        });
        await FirebaseFirestore.instance.collection('User').doc(
            FirebaseAuth.instance.currentUser.email).get()
            .then((callback) async {
          monthIncome = callback.data()['${month}Income'];
          monthExpend = callback.data()['${month}Expend'];
          totalIncome = callback.data()['total_income'];
        });
        if (int.parse(amount.text) > 0) {
          await FirebaseFirestore.instance.collection('User').doc(
              FirebaseAuth.instance.currentUser.email)
              .update({
            '${month}Income': (monthIncome + int.parse(amount.text)),
            'total_income':(totalIncome + int.parse(amount.text)),
          });
        } else {
          await FirebaseFirestore.instance.collection('User').doc(
              FirebaseAuth.instance.currentUser.email)
              .update({
            '${month}Expend': (monthExpend + int.parse(amount.text)),
          });
        }
      } on FirebaseException catch (e) {
        print(e);
        info = "Error";
      }
      info = "Transaction Added Successfully";
    }
    final snackBar = SnackBar(content: Text(info.toString()));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Future.delayed(Duration(seconds: 1),(){
      Navigator.pop(context);
      setState(() {
        amount.text="";
        description.text="";
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