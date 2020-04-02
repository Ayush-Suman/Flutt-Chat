import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class signInServices{
  
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  Future signInUsingEmail(String email, String password) async{
    return await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => value);
  }

  Future logOut() async{
    return await _auth.signOut();
  }

  Future googleSignIn() async{
    GoogleSignInAccount _googleSignInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleSignInAuthentication = await _googleSignInAccount.authentication;
    final AuthCredential _authCredential = GoogleAuthProvider.getCredential(idToken: _googleSignInAuthentication.idToken, accessToken: _googleSignInAuthentication.accessToken);
    return await _auth.signInWithCredential(_authCredential);
  }
}