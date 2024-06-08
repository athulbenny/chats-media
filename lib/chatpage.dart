import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:heychats/main.dart';

import 'home.dart';




class InnerPage extends StatefulWidget {
  const InnerPage({required this.owner, required this.friend});
  static final String id = "innerpage";
  final String owner,friend;

  @override
  State<InnerPage> createState() => _InnerPageState(owner,friend);
}

class _InnerPageState extends State<InnerPage> {
  String owner,friend;_InnerPageState(this.owner,this.friend);
  Future<dynamic> generateChatDetails() async {
    print(owner+"-"+ friend);//function to get data
    String chat=owner+friend;
    var url =Uri.http(ip,'/trailrun/getChatData.php');
    var response = await http.post(url, body:{
      "tablename": chat,
      // "isVisited":isVisited.toString(),
      // "Tdate":tdate,
    });print("response generateChatDetails is "+response.body);
    var list = json.decode(response.body);
    List<ChatDetails> chatDetails =
    await list.map<ChatDetails>((json) => ChatDetails.fromJson(json)).toList();
    return chatDetails;
  }

  Future<dynamic> addChatDetails() async {
    print(owner);//function to get data
    String chat1=owner+friend;String chat2=friend+owner;
    var url =Uri.http(ip,'/trailrun/sendChatData.php');
    var response = await http.post(url, body:{
      "tablename1": chat1,
      "tablename2":chat2,
      "msgs":message.text,
      // "isVisited":isVisited.toString(),
      // "Tdate":tdate,
    });print("response addChatDetails is "+response.body);
    var list = json.decode(response.body);
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
      return Scaffold(
        body: InnerPage(owner: owner,friend: friend),
      );
    })
    );
  }

  TextEditingController message=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.keyboard_backspace_outlined)
          ,onPressed: (){
            Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
              return Home(owner: owner);
            })
            );
          },),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),toolbarHeight: 70,
        backgroundColor: Colors.green[900],
        title:  Center(child:
        Text(friend,style: TextStyle(color: Colors.white,
            fontSize: 25,fontWeight:FontWeight.w900),)),
      ),
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<dynamic>(
                  future: generateChatDetails(),
                  builder: (context, snapshot) {
                    List<String> chatmsgslist=[];
                    List<int> chatidlist=[],chatstatusList=[];
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'no messages',
                            style: TextStyle(fontSize: 25),
                          ),
                        );
        
                        // if we got our data
                      } else if (snapshot.hasData) {
        
                        for(int i=0;i<snapshot.data.length;i++){
                          chatidlist.add(snapshot.data[i].id);
                          chatmsgslist.add(snapshot.data[i].msgs);
                          chatstatusList.add(snapshot.data[i].statues);
                        }
                        //print(tdate);
                        //print(notvisit);
                        return Container( padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/100,
                            right: MediaQuery.of(context).size.height/100),
                          height: MediaQuery.of(context).size.height/1.24,
                          child: Personal(friend:friend,owner:owner,msgsList:chatmsgslist,statusList:chatstatusList,idList:chatidlist),
                        );
                      }
                    }
                    return CircularProgressIndicator();
                  }
              ),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width/1.15,
                    child: TextField(
                      controller: message,
                      decoration: InputDecoration(
                          hintText: 'send message',border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  IconButton(onPressed: (){
                    if(message.text.isNotEmpty) {
                      addChatDetails();
                      Navigator.of(context).push(
                          MaterialPageRoute<void>(builder: (context) {
                            return Scaffold(
                              body: InnerPage(owner: owner, friend: friend),
                            );
                          })
                      );
                    }
                  }, icon: Icon(Icons.send))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Personal extends StatefulWidget {
  const Personal({required this.friend,required this.owner,required this.msgsList,required this.statusList,required this.idList});
  static final String id="personal";
  final List<String> msgsList;final String owner,friend;
  final List<int> idList,statusList;

  @override
  State<Personal> createState() => _PersonalState(owner,friend,msgsList,statusList);
}

class _PersonalState extends State<Personal> {
  String owner,friend;List<String> msgsList;
  List<int> statusList;
  _PersonalState(this.owner,this.friend,this.msgsList,this.statusList);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.orange,
        child: ListView.builder(
          itemCount: msgsList.length,
          itemBuilder: (BuildContext context, int index) {
            if(statusList[index]==0) {
              return Align(
                alignment: Alignment.bottomRight,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  child : Container(
                    padding: EdgeInsets.all(10),
                    child: Text(msgsList[index]), //to be changed
                ),
              ),
              );
            }else{
              return Align(
                alignment: Alignment.bottomLeft,
                child: Card(
                  color: Colors.blue,
                  elevation: 20,
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(msgsList[index],style: TextStyle(color: Colors.white),)), //to be changed
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ChatDetails{
  int id,statues;
  String msgs;
  ChatDetails({required this.id,required this.statues, required this.msgs});

  factory ChatDetails.fromJson(Map<String, dynamic> json) {
    return ChatDetails(
      id: int.parse(json['id']),
      statues: int.parse(json['statues']),
      msgs: json['msgs'] as String,
      //      isVisited: int.parse(json['isVisited']));
    );
  }
}