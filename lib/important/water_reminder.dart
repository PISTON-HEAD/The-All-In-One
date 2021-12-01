
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  updater(int add)async{
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
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("Daily Update", DateTime.now().toString());
    FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Hydro Alert").doc(auth.currentUser?.uid).collection("Water Table").doc("${DateTime.now().toString().substring(0,16)}").set({
      "Total Consumption":totalConsumption,
      "Completion Rate":(totalConsumption/maxConsume * 100).ceil(),
      "Counter":counter,
      "id":auth.currentUser?.uid,
      "Remaining":totalConsumption >= maxConsume?0:maxConsume - totalConsumption,
      "Date":DateTime.now().toString().substring(0,16),
    });
  }

  var changes="";
  getAllInfo()async{
    FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Hydro Alert").doc(auth.currentUser?.uid).get().then((value){
      if(value["Counter"] != null){
        totalConsumption = value["Todays Consumption"];
        counter = value["Counter"];
        currentDivision =value["Division"];
        maxConsume = value["Max Consumption"];
        minConsume = value["Min Consumption"];
      }
    }).whenComplete(()async{
      SharedPreferences sp = await SharedPreferences.getInstance();
      var now =  sp.getString("Daily Update");
      changes = now!;
      if(DateTime.now().toString().substring(8,10 ) != now.toString().substring(8,10 )){
        print("System Updated...");
        sp.setString("Daily Update", DateTime.now().toString());
        checker();
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


   checker()async{
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
          "Date":changes,
          "id":auth.currentUser?.uid,
        }).whenComplete(() => resetAll(),);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.more_vert_rounded,color: Colors.white,size: 25,),
          onPressed: (){
            resetAll();
          },)
        ],
        elevation: 0,
        backgroundColor: Colors.black,
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
                  height: MediaQuery.of(context).size.width / 1.2,
                  width: MediaQuery.of(context).size.width/1.0,
                  decoration: const BoxDecoration(
                      color:Colors.black, //Color.fromARGB(255, 5, 10, 48),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(75),
                          bottomRight: Radius.circular(75))),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment:Alignment.center,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: CircularPercentIndicator(
                                radius: 240,
                                animateFromLastPercent: true,
                                animation: true,
                                circularStrokeCap: CircularStrokeCap.round,
                                  linearGradient: LinearGradient(colors: [
                                    Color.fromARGB(255, 31,175,240),
                                    Color.fromARGB(255, 169,250,250),
                                  ]),
                                percent: snapshot.data?.docs == null?currentDivision:snapshot.data?.docs[0]["Division"],
                                lineWidth: 15,
                                backgroundColor: Colors.white,
                                //progressColor: const Color.fromARGB(255, 30, 171, 243),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/10),
                              child: const CircleAvatar(
                                radius: 90,
                                backgroundColor: Color.fromARGB(255, 214, 242, 253),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width/7),
                              child: Material(
                                borderRadius: BorderRadius.circular(70),
                                elevation: 15,
                                child: GestureDetector(
                                  onTap: (){
                                    waterCalculator();
                                    updater(200);
                                  },
                                  child: const CircleAvatar(
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
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Merriweather"),
                        )
                      ],
                    ),
                  ),
                ),
                //water information
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: [
                      const Divider(height: 50,thickness: 5,),
                      Column(
                        children: [
                          Text("Remaining",style: waterInfoStyle(),),
                          snapshot.data?.docs != null?Text(snapshot.data?.docs[0]["Todays Consumption"] >= snapshot.data?.docs[0]["Max Consumption"]?"0":"${snapshot.data?.docs[0]["Max Consumption"] - snapshot.data?.docs[0]["Todays Consumption"]} ml",style: waterInfoStyle(),)
                              :Text(totalConsumption >= maxConsume?"0":"${maxConsume - totalConsumption}"),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Completion",style: waterInfoStyle(),),
                          snapshot.data?.docs != null?Text("${(snapshot.data?.docs[0]["Division"]*100).toString().substring(0,3)}%",style: waterInfoStyle(),)
                              :Text("0%"),
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
                Container(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("Server Info").doc(auth.currentUser?.uid).collection("Daily Status").snapshots(),
                    builder: (context, snapshot) {
                      return Container(
                        child: ListView.builder(
                            reverse: true,
                            scrollDirection: Axis.vertical,
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs == null?0: snapshot.data?.docs.length,
                            itemBuilder: (context,index){
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.cyan)
                                ),
                                child: ListTile(
                                  onTap: (){},
                                  title:Row(
                                    children: [
                                      Icon(FontAwesomeIcons.tint,color: Colors.blue,),
                                      Text("  Intake: ${snapshot.data?.docs[index]["Todays Consumption"]}"),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      SizedBox(width: 25,height: 7,),
                                      Text("  ${snapshot.data?.docs[index]["Date"].toString().substring(0,11)}"),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  ),
                ),
              ],
            );
          }
        ),
      ),
    ));
  }

  TextStyle waterInfoStyle() {
    return const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Merriweather",
                    );
  }
}
