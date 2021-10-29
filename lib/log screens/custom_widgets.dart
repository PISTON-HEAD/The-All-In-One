import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar appBarWidget() {
  return AppBar(
      iconTheme: IconThemeData( color: Colors. black,),
    backgroundColor: Colors.white,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const[
        Text("Today's ",style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w800,
          color: Colors.black,
          fontFamily:"Merriweather",
        ),),
        Text("News",style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w900,
          color: Colors.pink,
          fontFamily:"Merriweather",
        ),),
      ],
    ),
  );
}
