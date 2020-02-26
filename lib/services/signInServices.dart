import 'package:firebase_auth/firebase_auth.dart';

class signInServices{
  
  final FirebaseAuth _auth= FirebaseAuth.instance;
  
  Future signInUsingEmail(String email, String password) async{
    return await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => value);
  }

  Future logOut() async{
    return await _auth.signOut();
  }
}