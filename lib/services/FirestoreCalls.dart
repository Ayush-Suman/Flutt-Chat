import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat/Users.dart';
import 'package:flutter_appchat/Chat.dart';

class firestoreCalls {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  String name="Loading";


  Future<List<Users>> getUsers(String uid) async {
    try {
      final List<Users> lusers = [];
      QuerySnapshot _querySnapShot =
          await _firestore.collection("Users").getDocuments();
      List<DocumentSnapshot> _list = _querySnapShot.documents;
      int i = 0;
      while (i < _list.length) {
          DocumentSnapshot cur = _list[i];
          lusers.add(Users(cur.data["name"], cur.documentID));
          i++;
      }
      name=lusers.firstWhere((element) => element.id==uid).name;
      lusers.removeWhere((element) => element.id==uid);
      return lusers;
    } catch (e) {
      print(e);
    }
  }

  Future<List<Chat>> getChats(String uids) async{
    try {
      final List<Chat> lchat = [];
      QuerySnapshot _querySnapShot = await _firestore.collection("Chats").document(uids).collection("Chats").orderBy("time", descending: true).getDocuments();
      List<DocumentSnapshot> _list =_querySnapShot.documents;
      int i =0;
      while(i<_list.length){
        DocumentSnapshot cur = _list[i];
        lchat.add(Chat(cur.data["chat"], cur.data["sentby"], cur.data["time"]));
        i++;
      }

      return lchat;
    } catch(e){
      print(e);
    }
  }

  Future sendMessage(String chat, String sentby, String time, String uids) async{
    return await _firestore.collection("Chats").document(uids).collection("Chats").document().setData({
      'chat': chat,
      'sentby': sentby,
      'time': time
    });
  }

  Future putNewUserData(String id, String name) async{
    return await _firestore.collection("Users").document(id).setData({
      'name' : name
    });
  }
}
