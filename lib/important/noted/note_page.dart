import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoteCreator extends StatefulWidget {
  const NoteCreator({Key? key}) : super(key: key);

  @override
  _NoteCreatorState createState() => _NoteCreatorState();
}

class _NoteCreatorState extends State<NoteCreator> {

  TextEditingController editingController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();
  final formKey = GlobalKey<FormState>();

  FirebaseAuth auth =  FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 17,128,197),
        title: Text("New Note"),
      ),
      backgroundColor: Color.fromARGB(255, 214,228,238),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            MaterialButton(
              elevation: 10,
              onPressed: () {
                if(formKey.currentState!.validate()){
                  FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Notes").doc(DateTime.now().toString()).set(
                      {
                      "Title":editingController.text,
                        "UserName":auth.currentUser?.displayName,
                        "Body":noteController.text,
                        "Time":DateTime.now().toString(),
                      }).whenComplete(() => Navigator.of(context).pop());
                }
              },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child:Text("SAVE"),
            ),
            ),
            Container(
              child: Column(children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val){
                    return val!.length < 1?"Enter the title":null;
                  },
                  controller: editingController,
                ),
                TextFormField(
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  controller: noteController,
                ),
              ],),
            ),
          ],
        ),
      ),
    );
  }
}
