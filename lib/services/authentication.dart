import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore= FirebaseFirestore.instance;
  final FirebaseAuth _auth =FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name
  }) async {
    String res = "Some error Occurred";
    try{
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        if(credential.user != null) {
          await _firestore.collection("users").doc(credential.user!.uid).set({
            'name':name,
            'email':email,
            'uid':credential.user!.uid,
            'languageCode': 'en'
          });
          res = "Success";
          return res;
        }
      }
    } on FirebaseAuthException catch(e) {
      if(e.code == 'email-already-in-use') return "Email already registered";
      if(e.code.isNotEmpty) return e.code;
      return e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async{
    String res = "Some error Occurred";
    try{
      if (email.isNotEmpty || password.isNotEmpty) {
        var response = await _auth.signInWithEmailAndPassword(email: email, password: password);
        if(response.user != null) {
          res = "Success";
          return res;
        }
      }
    } on FirebaseAuthException catch(e) {
      if (e.code == 'invalid-credential') return "Invalid Credential";
      if(e.code == 'user-not-found') return 'User Not Found';
      if(e.code.isNotEmpty) return e.code;
      return e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}


