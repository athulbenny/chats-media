import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'package:heychats/home.dart';
import 'package:heychats/main.dart';
import 'package:heychats/register.dart';





class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static final String id="login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  Future<void> verifydata() async {// function to send data
    final response = await http.post(Uri.http(ip,"/trailrun/verifylogin.php"), body: {
      "username": username1.text,
      "password": passsord1.text,});
    //String tdate=DateTime.now().toString();
    //(DateTime.parse("2023-5-18")==DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day))? print("tdate"):print("hai");
    if(response.body==""){
      ScaffoldMessenger.of(context).showSnackBar( // is this context <<<
          const SnackBar(content: Text('Invalied username or password...login failed',
            style: TextStyle(color: Colors.red),)));
    }else{print(response.body);
    var list = json.decode(response.body);
    List<Chater> chater =
    await list.map<Chater>((json) => Chater.fromJson(json)).toList();
    print(chater);

    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (context){
      return Scaffold(
          body: Home(owner: chater[0].username)//Individual(pid: policeid[0].pid),
      );
    })
    );
    }
  }

  TextEditingController username1=new TextEditingController();
  TextEditingController passsord1=new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: (){exit(0);},),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),toolbarHeight: 70,
        backgroundColor: Colors.green,
        title: const Center(child:
        Text('Login',style: TextStyle(
            fontSize: 25,fontWeight:FontWeight.w900),)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.comment),
            tooltip: 'Comment Icon',
            onPressed: () {},
          ), //IconButton
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Setting Icon',
            onPressed: () {},
          ), //IconButton
        ],
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(children:[
            const Expanded(flex:1,child: Text("Username",style: TextStyle(fontSize: 18.0,color: Colors.red),)),
            Expanded(flex: 3,
              child: TextField(
                controller: username1,
                decoration: const InputDecoration(
                    hintText: 'username',border: OutlineInputBorder()
                ),
              ),
            ),]),SizedBox(height: 20,),
          Row(children:[
            Expanded(flex:1,child: Text("Password",style: TextStyle(fontSize: 18.0,color: Colors.red),)),
            Expanded(flex: 3,
              child: TextField(
                controller: passsord1,obscureText: true,
                decoration: InputDecoration(
                    hintText: 'password',border: OutlineInputBorder()
                ),
              ),
            ),]),SizedBox(height: 50,),
          Theme(
            data: Theme.of(context).copyWith(
              hoverColor: Colors.green,
              colorScheme:
              Theme.of(context).colorScheme.copyWith(secondary: Colors.red),
            ),
            child:  FloatingActionButton(
              elevation: 25,
              child: Text("Login",
                style: TextStyle(fontSize: MediaQuery.of(context).devicePixelRatio*12),),
              onPressed: (){
                //Navigator.of(context).pushNamed(Home.id);
                verifydata();
                //Navigator.of(context).pushNamed(Register.id);
              },
            ),),SizedBox(height: MediaQuery.of(context).size.height/50,),
          TextButton(
            child: Text("Sign up"),
            onPressed: (){
              Navigator.of(context).pushNamed(Register.id);
            },
          ),
        ],
      ),
    );
  }
}
class Chater {
  String username;int phno;
  Chater({ required this.username,required this.phno});
  factory Chater.fromJson(Map<String, dynamic> json) {
    return Chater(
      username: json['username'] as String,
      phno: int.parse(json['phno']),
    );
  }
}