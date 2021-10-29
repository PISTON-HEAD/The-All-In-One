import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:new_app/News/the_news.dart';
import 'package:new_app/auth/firebase_auth.dart';
import 'package:new_app/auth/google_auth.dart';
import 'package:new_app/log%20screens/bottom_navigator.dart';
import 'package:new_app/log%20screens/forgot_pass.dart';
//2691/KZD/20211014563
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  IconData passWatcher = Icons.visibility_off_rounded;
  bool checkLogin = !true;
  bool obscureText = true;
  Color emailColor = Colors.grey;
  Color userColor = Colors.grey;
  Color passColor = Colors.grey;
  bool loadScreen = false;
  String errorMsg = "";


  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = new TextEditingController();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passController = new TextEditingController();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  signMeUp(){
    if(formKey.currentState!.validate()){
      setState(() {
        loadScreen =true;
      });
      print(passController.text);
      signUp(emailController.text, passController.text, userNameController.text).then((value) async {
        if(value != null){
          setState(() {
            loadScreen = false;
            for (int i = 1; i < value.toString().length; i++) {
              if (value.toString()[i] == "]") {
                errorMsg = value.toString().substring(i + 2);
              }
            }
          });
        }else{
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("LoggedIn", "true");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const TheNavigator()));
        }
      });
    }
  }
  logInUser(){
    if(formKey.currentState!.validate()){
      setState(() {
        loadScreen = true;
      });
      userLogIn(emailController.text, passController.text).then((value) async {
        if(value != null){
          setState(() {
            loadScreen = false;
            for (int i = 1; i < value.toString().length; i++) {
              if (value.toString()[i] == "]") {
                errorMsg = value.toString().substring(i + 2);
              }
            }
          });
        }else{
          FirebaseFirestore.instance
              .collection("Firebase User")
              .doc(firebaseAuth.currentUser!.uid)
              .update({
            "Password": passController.text,
            "Last SignedIn":DateTime.now(),
          });
          setState(() {
            loadScreen = true;
          });
          SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
          sharedPreferences.setString("LoggedIn", "true");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const TheNavigator()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: loadScreen == !true ? SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Form(
                key:formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      checkLogin == !true ? "Create Account," : "Welcome Back",
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      checkLogin == !true
                          ? "Sign up to get started!"
                          : "Sign in to continue!",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: CupertinoColors.inactiveGray,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 3.7,
                      child: Center(child: Container(
                        child:  Text("$errorMsg",style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 19,
                          color: Colors.red,
                        ),),
                      )),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: emailColor, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              emailColor = Colors.greenAccent;
                              passColor = Colors.grey;
                              userColor = Colors.grey;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              emailColor = Colors.grey;
                            });
                          },
                          controller: emailController,
                          cursorColor: Colors.black,
                          cursorWidth: 3,
                          style: textFieldStyle(),
                          autocorrect: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value.toString().contains(" ")) {
                              return "Enter an email without space";
                            } else if (RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value.toString())) {
                              return null;
                            } else {
                              return "Enter valid Email";
                            }
                          },
                          decoration: const InputDecoration(
                              labelText: "Email id",
                              hintText: "enter Email",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              ))),
                        )),
                    SizedBox(
                      height: checkLogin ==!true?MediaQuery.of(context).size.width / 25:0,
                    ),
                   checkLogin == !true? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: userColor, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              emailColor = Colors.grey;
                              passColor = Colors.grey;
                              userColor = Colors.greenAccent;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              userColor = Colors.grey;
                            });
                          },
                          controller: userNameController,
                          cursorColor: Colors.black,
                          cursorWidth: 3,
                          style: textFieldStyle(),
                          autocorrect: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return value.toString().length < 7
                                ? "Minimum character should be 8"
                                : value.toString().contains(" ")
                                    ? "Space is not allowed"
                                    : null;
                          },
                          decoration: const InputDecoration(
                              labelText: "user name",
                              hintText: "enter user name",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                color: Colors.white,
                              ))),
                        )):SizedBox(),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 25,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                            border: Border.all(color: passColor, width: 3),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          onTap: () {
                            setState(() {
                              emailColor = Colors.grey;
                              passColor = Colors.greenAccent;
                              userColor = Colors.grey;
                            });
                          },
                          onFieldSubmitted: (value) {
                            setState(() {
                              passColor = Colors.grey;
                            });
                          },
                          cursorColor: Colors.black,
                          cursorWidth: 3,
                          style: textFieldStyle(),
                          autocorrect: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            String val = value.toString().toLowerCase();
                            int charCounter = 0;
                            if (value.toString().isEmpty ||
                                value.toString().length < 8) {
                              return "character required is 8";
                            } else {
                              for (int i = 0; i < value.toString().length; i++) {
                                if (val.codeUnitAt(i) >= 97 &&
                                    val.codeUnitAt(i) <= 122) {
                                } else {
                                  charCounter++;
                                }
                              }
                              return charCounter != 0
                                  ? null
                                  : "Enter characters other than alphabets, ex: 1,/,-...";
                            }
                          },
                          controller: passController,
                          decoration: InputDecoration(
                            labelText: "password",
                            hintText: "enter password",
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passWatcher == Icons.visibility_off_rounded
                                      ? passWatcher = Icons.visibility
                                      : passWatcher =
                                          Icons.visibility_off_rounded;
                                });
                              },
                              icon: Icon(passWatcher),
                            ),
                          ),
                          obscureText: passWatcher == Icons.visibility_off_rounded
                              ? true
                              : !true,
                        )),
                    checkLogin==true?Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => forgotPassword()));
                          },
                          child:const Text("forgot password?",style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),)
                        ),
                      ],
                    ):SizedBox(),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 8,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 250, 87, 142),
                              Color.fromARGB(
                                255,
                                253,
                                168,
                                142,
                              ),
                            ],
                            stops: [
                              0.3,
                              0.7
                            ]),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          if(checkLogin == true){
                            print("logging In");
                            logInUser();
                          }else{
                            print("Signing Up");
                            signMeUp();
                          }
                        },
                        child: Center(
                            child: Text(
                          checkLogin == !true ? "Sign Up" : "Log In",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width / 24,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 235, 238, 244),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          googleSigner().then((value){
                            if(value != null){
                              setState(() {
                                loadScreen = !true;
                                errorMsg = value;
                              });
                            }else{
                              setState(() {
                                loadScreen = true;
                              });
                              print("Google Auth Confirmed");
                            }
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network("https://kgo.googleusercontent.com/profile_vrt_raw_bytes_1587515358_10512.png",fit: BoxFit.contain,),
                            ),
                            const Text(
                              "Connect with google",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 38,71,140),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:checkLogin == !true? MediaQuery.of(context).size.width/5:MediaQuery.of(context).size.width/3.5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(checkLogin == !true?"I'm already a user, ":"I'm a new user, ",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight:FontWeight.w700,
                          ),),
                        TextButton(
                          onPressed: (){
                            setState(() {
                              checkLogin == !true?checkLogin = true:checkLogin = !true;
                            });
                          },
                          child: Text(checkLogin==!true?"Log In":"Sign Up", style: const TextStyle(color: Colors.pinkAccent,
                            fontSize: 16,
                            fontWeight:FontWeight.w800,),),
                        )
                      ],
                    ),
                  ],
                ),
              )),
        ):Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(color: Colors.pink,strokeWidth: 3,),
          ),
        ),
      ),
    );
  }

  TextStyle textFieldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }
}

//https://www.youtube.com/watch?v=0snEunUacZY