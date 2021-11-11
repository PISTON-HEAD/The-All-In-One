import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'noted/note_page.dart';

class NoteIt extends StatefulWidget {
  const NoteIt({Key? key}) : super(key: key);

  @override
  _NoteItState createState() => _NoteItState();
}

class _NoteItState extends State<NoteIt> {

  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 17,128,197),
      ),
      backgroundColor: Color.fromARGB(255,229,237,241),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Notes").snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context,index){
              int? c = snapshot.data?.docs.length;
                return Container(
                  height: MediaQuery.of(context).size.width/2.5,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                    //border: Border.all(color: Colors.amber),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
                  child: ListTile(
                    title: Text("${snapshot.data?.docs[index]["Title"]}"),
                  ),
                );
              });
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 17,128,197),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>NoteCreator()));
        },
        child: Icon(Icons.add_circle_outline),
      ),
    );
  }
}
