import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextEditor extends StatefulWidget {
  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar:  AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
           IconButton(
              icon:const Icon(FontAwesomeIcons.alignLeft), onPressed: () {}),
           IconButton(
              icon:const Icon(FontAwesomeIcons.alignCenter), onPressed: () {}),
           IconButton(
              icon: const Icon(FontAwesomeIcons.alignRight), onPressed: () {}),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: name,
                decoration:const InputDecoration(
                  hintText: 'Insert your message',
                  hintStyle: TextStyle(color: Colors.white),
                  alignLabelWithHint: true,
                ),
                scrollPadding:const EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: 99999,
                style: const TextStyle(
                  color: Colors.white,
                ),
                autofocus: true,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar:  Container(
        color: Colors.white,
        padding:const EdgeInsets.all(10),
        child:  FlatButton(
            onPressed: () {
              Navigator.pop(context, name.text);
            },
            color: Colors.black,
            padding: const EdgeInsets.all(15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: const Text(
              'Add Text',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.white),
            )),
      ),
    );
  }
}
