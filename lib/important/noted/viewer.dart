import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class NotesViewer extends StatefulWidget {
  var doc;
  NotesViewer({Key? key, required this.doc}) ;

  @override
  _NotesViewerState createState() => _NotesViewerState(doc);
}

class _NotesViewerState extends State<NotesViewer> {
  _NotesViewerState(doc);
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void initState() {
    title = TextEditingController(text: widget.doc["Title"]);
    body = TextEditingController(text: widget.doc["Body"]);
    // TODO: implement initState
    super.initState();
  }

  theUpdater(){
    if(formKey.currentState!.validate()){
      if(widget.doc["Title"] != title.text || widget.doc["Body"] != body.text ){
        FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser!.uid).collection("Notes").doc(DateTime.now().toString()).set({
        "Title":title.text,
          "Body":body.text,
          "Time":DateTime.now().toString(),
          "User Name":auth.currentUser?.displayName,
        }).whenComplete((){
          widget.doc.reference.delete();
          Navigator.of(context).pop();
        });
      }else{
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [IconButton(
            onPressed: (){
              theUpdater();
            },
            icon: Icon(Icons.save),
          )],
        ),
        body: Form(
          key:formKey,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (val){
                    return val!.length <= 0 ||   val.startsWith(" ") ?  "cannot be empty": null;
                  },
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  controller: title,
                ),
                TextFormField(
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  controller: body,
                ),
                SizedBox(height: 20,),
                Text(widget.doc["Time"].toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

