import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat/screens/chatlist.dart';
import 'package:flutter_appchat/services/signInServices.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final signInServices _signInServices = signInServices();
  final TextEditingController Email = TextEditingController();
  final TextEditingController Password = TextEditingController();
  bool _obscureText = true;
  Color _color;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AnimationController _controller;

  bool loginClickable=true;

  @override
  void initState(){
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _controller.addListener(() {setState(() {

    });});
  }

  double blurRadiusblack = 10;
  double blurRadiuswhite = 16;
  double spreadRadiusblack = 1;
  double offset = 6;
  String SignInButton = "Sign In";

  double blurRadiusGoogle = 6;
  double spreadRadiusGoogle = -1;
  double offsetGoogle = 4;
  String GoogleSignInButton = "Google Sign In";


  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
      _color = _obscureText ? Colors.black : Colors.red[600];
    });
  }


  void signInComplete() {
    _controller.animateBack(0);
      SignInButton = "Sign In";

  }

  void GoogleSignIn() {
    setState(() {
      blurRadiusGoogle = 0;
      spreadRadiusGoogle = 0;
      offsetGoogle = 0;
      GoogleSignInButton = "Btn not handled";
    });
  }

  @override
  Widget build(BuildContext context) {
    _firebaseAuth.currentUser().then((value){
      if(value.uid!=null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => ChatList()));
      }
    });
    return Scaffold(
        body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewPortConstraints) {
      return Scaffold(
          backgroundColor: Colors.blue[200],
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
              child: Stack(children: [
            Container(
                constraints:
                    BoxConstraints(minHeight: viewPortConstraints.maxHeight),
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin:
                            EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
                        height: 300.0,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(230, 230, 230, 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(1.0, 3.0),
                                  blurRadius: 13.0,
                                  spreadRadius: -10.0)
                            ]),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 24.0, right: 24.0, bottom: 10.0),
                                  padding: EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 0.0,
                                      bottom: 0.0),
                                  child: Center(
                                      child: TextField(
                                    controller: Email,
                                    decoration: InputDecoration.collapsed(
                                        hintText: "Email",
                                        border: InputBorder.none),
                                  )),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.blue[200])),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: 24.0, right: 24.0, top: 10.0),
                                  padding: EdgeInsets.only(
                                      left: 30.0,
                                      right: 0.0,
                                      top: 0,
                                      bottom: 0),
                                  child: Center(
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                              child: TextFormField(
                                            controller: Password,
                                            decoration: InputDecoration(
                                              hintText: "Password",
                                              border: InputBorder.none,
                                            ),
                                            obscureText: _obscureText,
                                          )),
                                          FlatButton(
                                            onPressed: toggle,
                                            child: Icon(
                                              Icons.remove_red_eye,
                                              color: _color,
                                            ),
                                            shape: CircleBorder(),
                                          )
                                        ]),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(70),
                                      color: Colors.blue[200])),
                              Container(
                                  margin: EdgeInsets.fromLTRB(20, 50, 20, 30),
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromRGBO(230, 230, 230, 1.0),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(offset*(1-_controller.value), offset*(1-_controller.value)),
                                            blurRadius: blurRadiusblack*(1-_controller.value),
                                            spreadRadius: spreadRadiusblack*(1-_controller.value)),
                                        BoxShadow(
                                          color: Colors.white,
                                          offset: Offset(-offset*(1-_controller.value), -offset*(1-_controller.value)),
                                          blurRadius: blurRadiuswhite*(1-_controller.value),),
                                        BoxShadow(
                                            color: Color.fromRGBO(
                                                230, 230, 230, 1.0),
                                            offset: Offset(0.0, 0.0),
                                            blurRadius: 6.0)
                                      ]),
                                  child: FlatButton(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onPressed: () async {
                                        if(loginClickable){
                                          loginClickable=false;

                                          _controller.reset();
                                          _controller.forward().then((value) async{SignInButton = "Signing in...";
                                          FocusScope.of(context).requestFocus(FocusNode());
                                          try{
                                            AuthResult result =
                                                await _signInServices
                                                .signInUsingEmail(
                                                Email.text, Password.text);
                                            signInComplete();
                                            if(result.user.uid!=null){
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context)=>ChatList()));
                                            }else{
                                              loginClickable=true;
                                            }
                                          }catch(e){
                                            loginClickable=true;
                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                backgroundColor: Colors.white,
                                                content: Text("Something went wrong", style: TextStyle(color: Colors.black),)));
                                            print(e);
                                            signInComplete();
                                          }});

                                      }},
                                      child: Text(SignInButton)))
                            ])))),
            Align(
                alignment: Alignment.center,
                child: Container(
                    width: 200,
                    margin: EdgeInsets.only(
                        top: (viewPortConstraints.maxHeight / 2 + 200),
                        bottom: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromRGBO(230, 230, 230, 1.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(offsetGoogle, offsetGoogle),
                              blurRadius: blurRadiusGoogle,
                              spreadRadius: spreadRadiusGoogle)
                        ]),
                    child: FlatButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: GoogleSignIn,
                        child: Text(GoogleSignInButton))))
          ])));
    }));
  }
}
