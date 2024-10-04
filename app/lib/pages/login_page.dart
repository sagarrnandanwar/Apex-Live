import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  int bottomNavIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
          physics:BouncingScrollPhysics(),
          slivers:[

        ]
      )
    );
  }
}