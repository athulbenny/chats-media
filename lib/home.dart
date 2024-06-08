import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:heychats/chatpage.dart';
import 'package:heychats/main.dart';

import 'login.dart';





class Home extends StatefulWidget {
  const Home({required this.owner});
  static final String id="home";
  final String owner;

  @override
  State<Home> createState() => _HomeState(owner);
}

class _HomeState extends State<Home> {
  String owner;_HomeState(this.owner);

  Future<dynamic> generateFriendsList() async {
    print(owner);//function to get data
    var url =Uri.http(ip,'/trailrun/getfriendslist.php');
    var response = await http.post(url, body:{
      "tablename": owner,
      // "isVisited":isVisited.toString(),
      // "Tdate":tdate,
    });print("response generateFriendsList is "+response.body);
    var list = json.decode(response.body);
    List<Chater> chater =
    await list.map<Chater>((json) => Chater.fromJson(json)).toList();
    return chater;
  }

  Future<dynamic> createChatTable() async {
    print(owner);//function to get data
    String chat1 = owner + searchfriend.text.toString();
    String chat2 =  searchfriend.text.toString()+owner;
    var url =Uri.http(ip,'/trailrun/chattable.php');
    var response = await http.post(url, body:{
      "tablename1": chat1,
      'tablename2': chat2,
      'cname1':owner,
      'cname2':searchfriend.text,
    });print("response createChatTable is "+response.body);
    //var list = json.decode(response.body);
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
      return Scaffold(
        body: Home(owner: owner),
      );
    })
    );
  }

  TextEditingController searchfriend =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace_outlined)
          ,onPressed: (){
            Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
              return Login();
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
        title: const Center(child:
        Text('HeyChat',style: TextStyle(color: Colors.white,
            fontSize: 25,fontWeight:FontWeight.w900),)),
        actions: <Widget>[
          IconButton(
            color: Colors.white38,
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () {},
          ), //IconButton
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<dynamic>(
                future: generateFriendsList(),
                builder: (context, snapshot) {
                  List<String> userlist=[];
                  List<int> useridlist=[];
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'no friends',
                          style: TextStyle(fontSize: 25),
                        ),
                      );
        
                      // if we got our data
                    } else if (snapshot.hasData) {
        
                      for(int i=0;i<snapshot.data.length;i++){
                        useridlist.add(snapshot.data[i].id);
                        userlist.add(snapshot.data[i].users);
        
                      }
                      print(userlist);
                      //print(notvisit);
                      return Container( padding: EdgeInsets.only(left: MediaQuery.of(context).size.height/100,
                          right: MediaQuery.of(context).size.height/100),
                        height: MediaQuery.of(context).size.height/1.23,
                        child: ChatsApp(useridlist: useridlist,userlist: userlist,owner:owner,friend:searchfriend.text),
                      );
                    }
                  }
                  return CircularProgressIndicator();
                }
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height/20,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/1.5,
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Find Friends',border: OutlineInputBorder()
                        ),
                        controller: searchfriend,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width/20,),
                    FloatingActionButton(onPressed: (){
                      if(searchfriend.text.isNotEmpty) {
                        createChatTable();
                      }
                    }, child: Icon(Icons.search))
                  ],
                ),
              ),
            ),
          ],),
      ),
    );
  }
}



class ChatsApp extends StatefulWidget {
  const ChatsApp({required this.userlist,required this.useridlist,required this.owner, required this.friend});
  static final String id="chatsapp";
  final List<String> userlist; final List<int> useridlist;
  final String owner,friend;
  @override
  State<ChatsApp> createState() => _ChatsAppState(userlist,useridlist,owner,friend);
}

class _ChatsAppState extends State<ChatsApp> {
  List<String> userlist;List<int> useridlist;String owner,friend;
  _ChatsAppState(this.userlist,this.useridlist,this.owner,this.friend);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(//height: MediaQuery.of(context).size.height,
        child:ListView.builder(
          itemCount: userlist.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                child : Container(
                  padding: EdgeInsets.all(10),
                  child: Center(child: Text(userlist[index],style: TextStyle(fontSize: 23),)), //to be changed
                ),
              ),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
                  return Scaffold(
                    body: InnerPage(owner: owner,friend:userlist[index]),
                  );
                })
                );
                //Navigator.of(context).pushNamed(Personal.id);
              },
            );
          },
        ),
      ),
    );
  }
}

class Chater {
  int id;
  String users;

  Chater({ required this.id, required this.users});

  factory Chater.fromJson(Map<String, dynamic> json) {
    return Chater(
      id: int.parse(json['id']),
      users: json['ofname'] as String,
      //      isVisited: int.parse(json['isVisited']));
    );
  }
}

