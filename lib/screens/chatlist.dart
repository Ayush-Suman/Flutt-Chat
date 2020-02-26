import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat/services/signInServices.dart';
import 'package:flutter_appchat/screens/login.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool logoutClickable=true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  final signInServices _services = signInServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  double blurRadiusblack = 10;
  double blurRadiuswhite = 16;
  double spreadRadiusblack = 1;
  double offset = 6;
  String logOutButton = "Log Out";



  @override
  Widget build(BuildContext context) {
    _firebaseAuth.currentUser().then((value){
      if(value.uid==null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder:(context) => Login()));
      }
    });
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: Colors.blue[200],
        body: Builder(builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: statusBarHeight),
                  height: 100,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(230, 230, 230, 1.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            offset: Offset(1.0, 3.0),
                            blurRadius: 13.0,
                            spreadRadius: -10.0)
                      ]),
                  child: Row(children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(left: 20), child: Text("Name")),
                    Expanded(
                        child: Container(
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    width: 150,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color:
                                            Color.fromRGBO(230, 230, 230, 1.0),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(
                                                  offset *
                                                      (1 - _controller.value),
                                                  offset *
                                                      (1 - _controller.value)),
                                              blurRadius: blurRadiusblack *
                                                  (1 - _controller.value),
                                              spreadRadius: spreadRadiusblack *
                                                  (1 - _controller.value)),
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(
                                                -offset *
                                                    (1 - _controller.value),
                                                -offset *
                                                    (1 - _controller.value)),
                                            blurRadius: blurRadiuswhite *
                                                (1 - _controller.value),
                                          ),
                                          BoxShadow(
                                              color: Color.fromRGBO(
                                                  230, 230, 230, 1.0),
                                              offset: Offset(0.0, 0.0),
                                              blurRadius: 6.0)
                                        ]),
                                    child: FlatButton(

                                        onPressed: () async {
                                          if(logoutClickable){
                                            logoutClickable=false;
                                            _controller.reset();
                                            _controller.forward().then((value){logOutButton = "Logging out...";
                                          try {
                                            _services
                                                .logOut()
                                                .then((value) {
                                              _controller.animateBack(0);
                                              _auth.currentUser().then((value) {
                                                if (value == null) {
                                                  _controller.animateBack(0);
                                                  Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Login()));
                                                } else {
                                                  logoutClickable=true;
                                                  Scaffold.of(context)
                                                      .showSnackBar(SnackBar(
                                                    backgroundColor: Colors.white,
                                                          content: Text(
                                                              "Try Again", style: TextStyle(color: Colors.black))));
                                                }
                                              });
                                            });
                                          } catch (e){
                                            logoutClickable=true;
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.white,
                                                    content: Text(
                                                        "Something went wrong", style: TextStyle(color: Colors.black))));
                                          }});
                                          }
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Text(logOutButton))))))
                  ]))
            ],
          );
        }));
  }
}
