import 'package:flutter/material.dart';

import 'noted/note_page.dart';

class NoteIt extends StatefulWidget {
  const NoteIt({Key? key}) : super(key: key);

  @override
  _NoteItState createState() => _NoteItState();
}

class _NoteItState extends State<NoteIt> {

  int c= 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 17,128,197),
      ),
      backgroundColor: Color.fromARGB(255,229,237,241),
      body: ListView.builder(
        shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: c,
          itemBuilder: (context,index){
            return Container(
              height: MediaQuery.of(context).size.width/2.5,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                //border: Border.all(color: Colors.amber),
              ),
              margin: EdgeInsets.symmetric(horizontal: 25,vertical: 25),
              child: ListTile(),
            );
          }),
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
