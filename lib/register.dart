import 'package:flutter/material.dart';
import 'package:heychats/main.dart';
import 'package:http/http.dart' as http;
import 'login.dart';






class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  static final String id="register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController username1=new TextEditingController();
  TextEditingController passsord1=new TextEditingController();
  TextEditingController phno=new TextEditingController();

  bool validate=false,visible=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body:  SafeArea(
        child: SingleChildScrollView(scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Row(children:[
                Expanded(flex: 1,child: Text("Username",style: TextStyle(fontSize: 18.0),)),
                Expanded(flex:3,
                  child: TextField(
                    controller: username1,
                    decoration: InputDecoration(
                        hintText: 'username'
                    ),
                  ),
                ),]),
              SizedBox(height: 20,),
              Row(children:[
                Expanded(flex: 1,child: Text("Password",style: TextStyle(fontSize: 18.0),)),
                Expanded(flex:3,
                  child: TextField(
                    controller: passsord1,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        errorText: validate?"password must be eight character":""
                    ),
                  ),
                ),]),SizedBox(height: 20,),
              Row(children:[
                Expanded(flex: 1,child: Text("Phone number",style: TextStyle(fontSize: 18.0),)),
                Expanded(flex:3,
                  child: TextField(
                    controller: phno,
                    decoration: InputDecoration(
                        hintText: 'Phone number'
                    ),
                  ),
                ),]),SizedBox(height: 20,)
              ,SizedBox(height: 20,),
              ElevatedButton(
                child: Text("Register"),
                onPressed: (){
                  if(passsord1.text.length<8){
                    setState(() {
                      validate=true;
                    });
                  }else{
                    senddata();
                    Navigator.of(context).pushNamed(Login.id);
                  }},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> senddata() async{
    final response = await http.post(Uri.http(ip,"/trailrun/sendlogindata.php"), body: {
      "username": username1.text,
      "password": passsord1.text,
      "phno":phno.text,

    });print(response.body);
    if(response.body!="user added successfully"){
      ScaffoldMessenger.of(context).showSnackBar( // is this context <<<
          const SnackBar(content: Text('Username  is not valied',
            style: TextStyle(color: Colors.red),)));
    }else{Navigator.of(context).pushNamed(Login.id);}
  }
}

