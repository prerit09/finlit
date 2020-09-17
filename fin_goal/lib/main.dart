import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      accentColor: Colors.orange
    ),
    home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List todos = List();
  String input = "";

  createTodos(){
    DocumentReference documentReference = FirebaseFirestore.instance.collection("MyTodos").doc(input);

    //Map
    Map<String, String> todos = {
      "todosTitle": input
    };

    documentReference.set(todos).whenComplete(() => print ("$input created"));
  }

  deleteTodos(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
  title: Text("Fin Goal"),
  centerTitle: true),
  floatingActionButton: FloatingActionButton(
    onPressed: (){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ),
            title: Text("Add Income"),
            content: TextField(
              onChanged: (String value){
                input = value;
              },
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: (){
                createTodos();
        
                Navigator.of(context).pop();
              },
              child: Text("Add"))
            ],
          );
        });
    }, 
    child: Icon(
      Icons.add,
      color: Colors.white,
    ),
  ),
  
  body: StreamBuilder(stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(), builder: (context, snapshots){
        return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshots.data.documents.length ,
              itemBuilder: (context, index){
                DocumentSnapshot documentSnapshot = snapshots.data.documents[index];
                
                return Dismissible
                (key: Key(
                  index.toString()), 
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: ListTile(
                    title: Text(documentSnapshot.data()["todoTitle"]),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        ), 
                  onPressed: () {
                    setState(() {
                  todos.removeAt(index);
                });
              }),
            ),
          ));
        }) ;
      })
    );
  }
}