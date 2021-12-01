import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'noted/note_page.dart';
import 'noted/viewer.dart';

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
          return Container(
            child: ListView.builder(
              reverse: true,
              shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context,index){
                int? c = snapshot.data?.docs.length;
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => NotesViewer(doc: snapshot.data?.docs[index],)));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.width/2.5,
                      decoration:  BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                        border: Border.all(color: Colors.grey),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
                      child: SingleChildScrollView(
                        child: ListTile(
                          onLongPress: (){
                            showDialog(context: context, builder: (context){
                              return AlertDialog(
                                title: Text("Delete Note"),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: (){Navigator.of(context).pop();},
                                  ),
                                  TextButton(
                                    child: Text("Delete"),
                                    onPressed: (){
                                      snapshot.data?.docs[index].reference.delete().whenComplete(() => Navigator.of(context).pop());
                                    },
                                  ),
                                ],
                              );
                            });
                          },
                          dense: true,
                          title: Text("${snapshot.data?.docs[index]["Title"]}",style: const TextStyle(
                            fontFamily: "ZenTokyoZoo",
                          fontWeight:FontWeight.w600,
                            fontSize: 25,
                            inherit: true,
                          ),),
                          subtitle: Text("${snapshot.data?.docs[index]["Body"]}",style: const TextStyle(
                            fontFamily: "Merriweather",
                            fontWeight:FontWeight.w600,
                            fontSize: 16,
                            inherit: true,
                          ),),
                        ),
                      ),
                    ),
                  );
                }),
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 17,128,197),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NoteCreator()));
        },
        child: Icon(Icons.add_circle_outline),
      ),
    );
  }
}
