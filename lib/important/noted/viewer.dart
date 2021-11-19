import 'package:flutter/material.dart';
class NotesViewer extends StatefulWidget {
  final doc;
  const NotesViewer({Key? key, required this.doc}) : super(key: key);

  @override
  _NotesViewerState createState() => _NotesViewerState(doc);
}

class _NotesViewerState extends State<NotesViewer> {
  _NotesViewerState(doc);

  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();


  @override
  void initState() {
    title = TextEditingController(text: widget.doc["Title"]);
    body = TextEditingController(text: widget.doc["Body"]);
    // TODO: implement initState
    super.initState();
  }

  theUpdater(){

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

