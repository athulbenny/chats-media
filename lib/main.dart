import 'package:flutter/material.dart';
import 'package:heychats/register.dart';
import 'login.dart';

String ip="192.168.43.77:80";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login':(context)=>Login(),
      'register':(context)=>Register(),
      //'chatsapp':(context)=>ChatsApp(),
      //'personal':(context)=>Personal(),
    },
  ));
}


//const ChatsApp()


