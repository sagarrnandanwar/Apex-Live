import 'package:app/pages/login_page.dart';
import 'package:app/pages/user_page.dart';
import 'package:flutter/material.dart';

void main() {
  // startApp();
  runApp(const MainApp());
}

// Future<void> startApp() async {
//   await dotenv.load(fileName: ".env");
//   runApp(const MainApp());
// }

class MainApp extends StatelessWidget{
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserPage(),
      debugShowCheckedModeBanner: false,
      routes:{
        '/login': (context) => const LoginPage(),
        '/user': (context) => const UserPage(),
      }
    );
  }
}

