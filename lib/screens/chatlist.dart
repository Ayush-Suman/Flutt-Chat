import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat/services/FirestoreCalls.dart';
import 'package:flutter_appchat/services/signInServices.dart';
import 'package:flutter_appchat/screens/login.dart';
import 'package:flutter_appchat/Users.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firestoreCalls _calls = firestoreCalls();
  List<Users> users = [Users("Loading", "Fake")];

  bool logoutClickable = true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  final signInServices _services = signInServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String name="Loading";

  double blurRadiusblack = 10;
  double blurRadiuswhite = 16;
  double spreadRadiusblack = 1;
  double offset = 6;
  String logOutButton = "Log Out";

  @override
  Widget build(BuildContext context) {
    _firebaseAuth.currentUser().then((value) {
      if (value.uid == null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      } else {
        _calls.getUsers(value.uid).then((value) {
          setState(() {
            name=_calls.name;
            users = value;
          });
        });
      }
    });
    final statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: null,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue[200],
                  Colors.blue[300],
                  Colors.blue[400],
                  Color.fromARGB(255, 180, 70, 255)
                ]
            )
          ),
        child:Builder(builder: (BuildContext context) {
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
                        margin: EdgeInsets.only(left: 20), child: Text(name, style: TextStyle(fontSize: 18),)),
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
                                          if (logoutClickable) {
                                            logoutClickable = false;
                                            _controller.reset();
                                            _controller.forward().then((value) {
                                              logOutButton = "Logging out...";
                                              try {
                                                _services
                                                    .logOut()
                                                    .then((value) {
                                                  _controller.animateBack(0);
                                                  _auth
                                                      .currentUser()
                                                      .then((value) {
                                                    if (value == null) {
                                                      _controller
                                                          .animateBack(0);
                                                      Navigator.of(context)
                                                          .pushReplacement(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Login()));
                                                    } else {
                                                      logoutClickable = true;
                                                      Scaffold.of(context)
                                                          .showSnackBar(SnackBar(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              content: Text(
                                                                  "Try Again",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black))));
                                                    }
                                                  });
                                                });
                                              } catch (e) {
                                                logoutClickable = true;
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                        backgroundColor:
                                                            Colors.white,
                                                        content: Text(
                                                            "Something went wrong",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black))));
                                              }
                                            });
                                          }
                                        },
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Text(logOutButton))))))
                  ])),
              ListView.builder(
                itemBuilder: (context, position) {
                  return Container(
                    child: Align(alignment:Alignment.centerLeft,child:Text(
                      users[position].name,
                      style: TextStyle(fontSize: 20)
                    )),
                    height: 80,
                    margin: EdgeInsets.only(bottom: 2),
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(230, 230, 230, 1.0),
                      boxShadow: [BoxShadow(offset:Offset(1,1), blurRadius: 10, spreadRadius: -7)]
                    ),
                  );
                },
                itemCount: users.length,
                shrinkWrap: true,
              )
            ],
          );
        })));
  }
}
