import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

double getHeight(BuildContext context){
  return MediaQuery.of(context).size.height;
}

double getWidth(BuildContext context){
  return MediaQuery.of(context).size.width;
}