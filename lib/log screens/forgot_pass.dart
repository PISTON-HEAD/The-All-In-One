import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class forgotPassword extends StatefulWidget {
  const forgotPassword({Key? key}) : super(key: key);

  @override
  _forgotPasswordState createState() => _forgotPasswordState();
}

class _forgotPasswordState extends State<forgotPassword> {

  final formKey = GlobalKey<FormState>();
  Color fieldColor = Colors.grey;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = new TextEditingController();

  Future resetPass() async {
    try{
      firebaseAuth.sendPasswordResetEmail(email: emailController.text);
    }catch(e){
      if(e.toString().isEmpty){
        return null;
      }else{
        return e;
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Reset Password",style:TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
               color: CupertinoColors.label,
                ),),
                const SizedBox(
                  height: 5,
                ),
                const Text("Enter your email for a password reset  link to be send to your gmail account!",style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.inactiveGray,
                ),),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 3.7,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                        border: Border.all(color: fieldColor, width: 3),
                        borderRadius: BorderRadius.circular(10)),
                    child: Form(
                      key:formKey,
                      child: TextFormField(
                        onTap: () {
                          setState(() {

                            fieldColor = Colors.greenAccent;

                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            fieldColor = Colors.grey;
                          });
                        },
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
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "enter email",
                          hintText: "email",
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )),
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
                      if(formKey.currentState!.validate()){
                        resetPass().then((value){
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child:const Center(
                        child: Text(
                       "Send Link",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
TextStyle textFieldStyle() {
  return const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );
}