import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_appchat/services/FirestoreCalls.dart';
import 'package:flutter_appchat/Chat.dart';
import 'package:flutter_appchat/Users.dart';

class ChatScreen extends StatefulWidget {
  Users user;

  ChatScreen(this.user) : super();

  @override
  _ChatScreenState createState() => _ChatScreenState(user);
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _message = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final firestoreCalls _calls = firestoreCalls();
  final ScrollController _scrollController = ScrollController();
  List<Chat> chats = [Chat("Loading Chats", "gen", "0")];
  Users user;
  String selfid;
  String uids;

  _ChatScreenState(this.user) : super();

  @override
  Widget build(BuildContext context) {
    _firebaseAuth.currentUser().then((value) {
      selfid=value.uid;
      if (value.uid.hashCode < user.id.hashCode) {
        uids=value.uid+user.id;
        _calls.getChats(value.uid + user.id).then((value) {
          setState(() {
            chats = value;
          });
        });
      } else {
        uids=user.id+value.uid;
        _calls.getChats(user.id + value.uid).then((value) {
          setState(() {
            chats = value;
          });
        });
      }
    });

    double _topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewPortConstrains) {
      return Container(
          constraints: BoxConstraints(minHeight: viewPortConstrains.maxHeight),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.blue[200],
                Colors.blue[300],
                Colors.blue[400],
                Color.fromARGB(255, 100, 70, 255)
              ])),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: _topPadding),
              width: viewPortConstrains.maxWidth,
              decoration: BoxDecoration(color: Color.fromARGB(255, 230, 230, 230), boxShadow: [
                BoxShadow(
                    offset: Offset(0, 0),
                    color: Color.fromARGB(100, 0, 0, 0),
                    blurRadius: 10)
              ]),
              child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(user.name, style: TextStyle(fontSize: 20))),
            ),
            Expanded(
                child: ListView.builder(
                  reverse: true,
                  controller: _scrollController,
              itemBuilder: (context, position) {
                if(chats[position].sentby== "gen"){
                  return Container(
                    height: viewPortConstrains.maxHeight/1.5,
                    child: Align(alignment: Alignment.center, child:Text("Loading", style: TextStyle(fontSize: 30, color: Colors.black54),)),
                  );
                }
                if (chats[position].sentby == user.id) {
                  return Container(
                      constraints:
                          BoxConstraints(minWidth: viewPortConstrains.maxWidth),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Color.fromARGB(255, 230, 230, 240),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(5, -5),
                                      color: Color.fromARGB(100, 0, 0, 0),
                                      blurRadius: 10,
                                      spreadRadius: 0),
                                ]),
                            margin: EdgeInsets.only(left: 10, bottom: 5),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, right: 20, left: 10),
                                child: Text(chats[position].chat,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)))),
                      ));
                } else {
                  return Container(
                      constraints:
                          BoxConstraints(minWidth: viewPortConstrains.maxWidth),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(5, -5),
                                      color: Color.fromARGB(100, 0, 0, 0),
                                      blurRadius: 10,
                                      spreadRadius: 0)
                                ]),
                            margin: EdgeInsets.only(right: 10, bottom: 5),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, right: 20, left: 10),
                                child: Text(chats[position].chat,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black)))),
                      ));
                }
              },
              itemCount: chats.length,
              shrinkWrap: true,
            )),
            Container(
                height: 60,
                color: Color.fromARGB(255, 230, 230, 230),
                child: Row(children: <Widget>[
                  Expanded(
                      child: Padding(padding: EdgeInsets.only(left: 10, right: 10), child:TextField(
                        controller: _message,
                        decoration: InputDecoration.collapsed(hintText: "Write Here..."),
                        onSubmitted: (chat){
                          if(_message.toString().isNotEmpty){
                            _calls.sendMessage(chat, selfid , DateTime.now().millisecondsSinceEpoch.toString(), uids );
                          }
                          _message.clear();
                        },
                      )
                  )),
                  Padding(
                      padding: EdgeInsets.only(right: 10, left: 5),
                      child:
                          InkWell(onTap:(){
                            if(_message.toString().isNotEmpty){
                              _calls.sendMessage(_message.text, selfid , DateTime.now().millisecondsSinceEpoch.toString(), uids );
                              _scrollController.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                            }
                            _message.clear();
                          },
                            child:Icon(Icons.send, color: Colors.blue[600], size: 34,),
                  ))
                ]))
          ]));
    }));
  }
}
