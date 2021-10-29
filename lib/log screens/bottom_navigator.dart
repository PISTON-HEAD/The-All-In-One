import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_app/News/the_news.dart';
import 'package:new_app/important/dater.dart';
import 'package:new_app/important/expiry.dart';
import 'package:new_app/important/noted.dart';
import 'package:new_app/important/water_reminder.dart';


class TheNavigator extends StatefulWidget {
  const TheNavigator({Key? key}) : super(key: key);

  @override
  _TheNavigatorState createState() => _TheNavigatorState();
}

class _TheNavigatorState extends State<TheNavigator> {

  int initialIndex = 2;

  List allWidgets = [
    NoteIt(),
    WarrantyChecker(),
    MyNews(),
    water_reminder(),
    LetsDate(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: allWidgets[initialIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: initialIndex,
        backgroundColor: Colors.white54,
        buttonBackgroundColor: CupertinoColors.white,
        animationDuration: Duration(milliseconds: 500),
        color: Colors.pink.shade100,
        onTap: (val){
          setState(() {
            initialIndex = val;
          });
        },
        items: [
           Icon(initialIndex != 0?FontAwesomeIcons.clipboard:  FontAwesomeIcons.clipboardCheck),
          Icon(initialIndex != 1?Icons.check_circle_outlined: Icons.check_circle),
          Icon(initialIndex == 2?FontAwesomeIcons.newspaper:Icons.perm_device_information_outlined),
          Icon(initialIndex != 3?FontAwesomeIcons.glassWhiskey:Icons.local_drink_sharp),
          Icon(initialIndex == 4?Icons.favorite:Icons.favorite_border_sharp),
        ],
      ),
    );
  }
}
/*
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class water_reminder extends StatefulWidget {
  const water_reminder({Key? key}) : super(key: key);

  @override
  _water_reminderState createState() => _water_reminderState();
}

class _water_reminderState extends State<water_reminder> {
  int minConsume = 200;
  int totalConsumption = 0;
  int maxConsume = 2500;
  double totalDivisions = 0;
  double currentDivision = 0;
  bool onlyOnce = true;
  int counter = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  DateTime now = DateTime.now();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalDivisions = maxConsume/minConsume;
    getAllInfo();
    dailyUpdater();
  }

  dailyUpdater(){
    Timer.periodic(Duration(seconds: 1), (Timer t){

      setState(() {
        if(DateTime.now().toString().substring(11,19) =="23:00:00"){
            print("System Updated...");
          checker();
        }
      });
    });
  }

  waterCalculator(){
    setState(() {
      totalConsumption +=minConsume;
      counter+=1;
      currentDivision += (1/totalDivisions);
      if(currentDivision > 1){
        currentDivision = 1;
      }
    });
  }

  updater(int add){
    FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Hydro Alert").doc(auth.currentUser?.uid).set({
      "Todays Consumption":totalConsumption,
      "Max Consumption":maxConsume,
      "Min Consumption":minConsume,
      "Counter":counter,
      "Division":currentDivision,
      "Total Divisions":totalDivisions,
      "Completion Rate":(totalConsumption/maxConsume * 100).ceil(),
      "Remaining":totalConsumption >= maxConsume?0:maxConsume - totalConsumption,
      "Date":DateTime.now().toString().substring(0,16),
      "id":auth.currentUser?.uid,
    });

    FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Hydro Alert").doc(auth.currentUser?.uid).collection("Water Table").doc("${DateTime.now().toString().substring(0,16)}").set({
      "Total Consumption":totalConsumption,
      "Completion Rate":(totalConsumption/maxConsume * 100).ceil(),
      "Counter":counter,
      "id":auth.currentUser?.uid,
      "Remaining":totalConsumption >= maxConsume?0:maxConsume - totalConsumption,
      "Date":DateTime.now().toString().substring(0,16),
    });
  }

  getAllInfo(){
    FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Hydro Alert").doc(auth.currentUser?.uid).get().then((value){
      if(value["Counter"] != null){
        totalConsumption = value["Todays Consumption"];
        counter = value["Counter"];
        currentDivision =value["Division"];
        maxConsume = value["Max Consumption"];
        minConsume = value["Min Consumption"];
      }
    });
  }

  resetAll(){
    totalConsumption = 0;
    counter = 0;
    currentDivision = 0.0000000000000000000000000000000000000;
    FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Hydro Alert").doc(auth.currentUser?.uid).set({
      "Todays Consumption":0,
      "Max Consumption":maxConsume,
      "Min Consumption":minConsume,
      "Counter":0,
      "Division":0.00000000000000000000000000000000000001,
      "Total Divisions":totalDivisions,
      "Completion Rate":0,
      "Remaining":0,
      "Date":DateTime.now().toString().substring(0,16),
      "id":auth.currentUser?.uid,
    });
  }


  checker(){
    FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Daily Status").doc(DateTime.now().toString().substring(0,16)).set(
        {
          "Todays Consumption":totalConsumption,
          "Max Consumption":maxConsume,
          "Min Consumption":minConsume,
          "Counter":counter,
          "Division":currentDivision,
          "Total Divisions":totalDivisions,
          "Completion Rate":(totalConsumption/maxConsume * 100).ceil(),
          "Remaining":totalConsumption >= maxConsume?0:maxConsume - totalConsumption,
          "Date":DateTime.now().toString().substring(0,16),
          "id":auth.currentUser?.uid,
        });
    resetAll();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.more_vert_rounded,color: Colors.white,size: 25,),
          onPressed: (){
            resetAll();
          },)
        ],
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 5, 10, 48),
        title: const Text(
          "Hydro Alert",
          style: TextStyle(
            fontFamily: "Merriweather",
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Hydro Alert").snapshots(),
          builder: (context, snapshot){
            return  Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width / 1.25,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 5, 10, 48),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(75),
                          bottomRight: Radius.circular(75))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: CircularPercentIndicator(
                              radius: 240,
                              percent: snapshot.data?.docs == null?currentDivision:snapshot.data?.docs[0]["Division"],
                              lineWidth: 15,
                              backgroundColor: Colors.white70,
                              progressColor: Color.fromARGB(255, 30, 171, 243),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.width / 10,
                            right: MediaQuery.of(context).size.width / 14,
                            child: CircleAvatar(
                              radius: 90,
                              backgroundColor: Color.fromARGB(255, 214, 242, 253),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.width / 7,
                            right: MediaQuery.of(context).size.width / 8,
                            child: Material(
                              borderRadius: BorderRadius.circular(70),
                              elevation: 15,
                              child: GestureDetector(
                                onTap: (){
                                  waterCalculator();
                                  updater(200);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    30,
                                    171,
                                    243,
                                  ),
                                  radius: 70,
                                  child: Text(
                                    "Drink",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      //Water
                      SizedBox(
                        height: 10,
                      ),
                      Text(snapshot.data?.docs == null?"${totalConsumption / maxConsume}":
                        "${snapshot.data?.docs[0]["Todays Consumption"]} / ${snapshot.data?.docs[0]["Max Consumption"]} ml ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Merriweather"),
                      )
                    ],
                  ),
                ),
                //water information
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: [
                      Divider(height: 50,thickness: 5,),
                      Column(
                        children: [
                          Text("Remaining",style: waterInfoStyle(),),
                          snapshot.data?.docs != null?Text(snapshot.data?.docs[0]["Todays Consumption"] >= snapshot.data?.docs[0]["Max Consumption"]?"0":"${snapshot.data?.docs[0]["Max Consumption"] - snapshot.data?.docs[0]["Todays Consumption"]} ml",style: waterInfoStyle(),)
                              :Text(totalConsumption >= maxConsume?"0":"${maxConsume - totalConsumption}"),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Completetion",style: waterInfoStyle(),),
                          snapshot.data?.docs != null?Text(snapshot.data?.docs[0]["Todays Consumption"] ==0?"0": "${((snapshot.data?.docs[0]["Todays Consumption"]/snapshot.data?.docs[0]["Max Consumption"])*100).toString().substring(0,2)}",style: waterInfoStyle(),)
                              :Text("0"),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Consumption",style: waterInfoStyle(),),
                          Text(snapshot.data?.docs == null ? "$counter":"${snapshot.data?.docs[0]["Counter"]} nos",style: waterInfoStyle(),),
                        ],
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  dragStartBehavior: DragStartBehavior.start,
                  child: Container(
                    child: ListView.builder(
                      reverse: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                        itemCount: counter,
                        itemBuilder: (context,index){
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)
                        ),
                        child: ListTile(
                          onTap: (){},
                          title:Text("${minConsume+index} $index"),
                          tileColor: Colors.orangeAccent,
                        ),
                      );
                    }),
                  ),
                )

              ],
            );
          }
        ),
      ),
    ));
  }

  TextStyle waterInfoStyle() {
    return TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Merriweather",
                    );
  }
}

 */
