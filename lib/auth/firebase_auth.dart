import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final firebaseauth = FirebaseAuth.instance;

Future signUp(String email, String pass , String userName)async{
  try{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      UserCredential credential = await firebaseauth.createUserWithEmailAndPassword(email: email, password: pass);
      final fireUser =credential.user;
      final logger = (await FirebaseFirestore.instance.collection("Firebase Users").where("id",isEqualTo: fireUser!.uid).get()).docs;
      if(logger.isEmpty){
      print("Initializing Cloud new user signing...........accessing firestore");
      fireUser.updateDisplayName(userName);
      FirebaseFirestore.instance.collection("Firebase Users").doc(fireUser.uid).set({
        "Name":userName,
        "Email":email,
        "Password":pass,
        "Created Time":DateTime.now().microsecondsSinceEpoch,
        "Last SignedIn":DateTime.now().toString().toString().substring(0,16),
        "First Time":DateTime.now().toString().toString().substring(0,16),
        "id":fireUser.uid,
      });

      FirebaseFirestore.instance.collection("Server Info").doc(fireUser.uid).collection("Hydro Alert").doc(fireUser.uid).set({
        "Todays Consumption":0,
        "Max Consumption":2500,
        "Min Consumption":200,
        "Counter":0,
        "Division":0.00000000000000000000000000000000000001,
        "Total Divisions":2500/200,
        "Completion Rate":0,
        "Remaining":0,
        "Date":DateTime.now().toString().substring(0,16),
        "id":fireUser.uid,
      });

      print("Cloud Base creation Over");
      sharedPreferences.setString("id",fireUser.uid);
      sharedPreferences.setString("Name",userName);
      sharedPreferences.setString("Email",email);
      sharedPreferences.setString("Password",pass);
      sharedPreferences.setString("LoggedIn", "true");
      }
  }catch(error){
    print("The error: $error");
    if(error.toString().isEmpty){
      return null;
    }
    else{
      return error;
    }
  }
}

Future userLogIn(String email, String pass) async {
  try{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserCredential credential = await firebaseauth.signInWithEmailAndPassword(email: email, password: pass);
    final fireUser = credential.user;
    final logger = (await FirebaseFirestore.instance.collection("Firebase User").where("id",isEqualTo: fireUser!.uid).get()).docs;
    if(logger.isNotEmpty){
      print("Old User Signing...");
      sharedPreferences.setString("id",logger[0]["id"]);
      sharedPreferences.setString("Name",logger[0]["Name"]);
      sharedPreferences.setString("Email",logger[0]["Email"]);
      sharedPreferences.setString("Password",logger[0]["Password"]);
      sharedPreferences.setString("LoggedIn", "true");
    }
  }catch(error){
    if(error.toString().isEmpty){
      return null;
    }
    else{return error;}
  }
}