import 'package:app/utilities/input.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  int bottomNavIndex=0;
  TextEditingController name = TextEditingController(),password=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          physics:const BouncingScrollPhysics(),
          slivers:[
            Image.network(""),
            Input(controller: name, label: "name", icon: Icons.person),
            Input(controller: password, label: "password", icon: Icons.password),
          ]
      )
    );
  }
}