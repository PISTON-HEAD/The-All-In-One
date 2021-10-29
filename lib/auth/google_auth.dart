import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final googleSigning = GoogleSignIn();
final firebaseAuth = FirebaseAuth.instance;Future googleSigner()async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    GoogleSignInAccount? signInAccount = await googleSigning.signIn();
    GoogleSignInAuthentication signInAuthentication = await signInAccount!
        .authentication;
    AuthCredential credential = await GoogleAuthProvider.credential(
        idToken: signInAuthentication.idToken,
        accessToken: signInAuthentication.accessToken);
    final firebaseUser = (await firebaseAuth.signInWithCredential(credential))
        .user;

    if (firebaseUser != null) {
      final logger = (await FirebaseFirestore.instance.collection(
          "Google_Users").where("id", isEqualTo: firebaseUser.uid).get()).docs;
      if (logger.length == 0) {
        FirebaseFirestore.instance.collection("Google Users").doc(
            firebaseUser.uid).set({
          "id": firebaseUser.uid,
          "name": firebaseUser.displayName,
          "email": firebaseUser.email,
          "phone number": firebaseUser.phoneNumber,
          "Photo": firebaseUser.photoURL,
          "Last Signed In": DateTime.now()
        });

        sharedPreferences.setString("id", firebaseUser.uid);
        sharedPreferences.setString("name", firebaseUser.displayName.toString());
        sharedPreferences.setString("email", firebaseUser.email.toString());
        sharedPreferences.setString("phone number", firebaseUser.phoneNumber.toString());
        sharedPreferences.setString("photo", firebaseUser.photoURL.toString());
      }
    }
  } catch (error) {
    if(error.toString().isEmpty){
      return null;
    }else{
      return error;
    }
  }
}