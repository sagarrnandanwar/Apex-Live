import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var bottomNavIndex = 0;
  var isAdmin=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(

        slivers: [
          SliverAppBar(
            floating: true,
            pinned:false,
            title: Text(bottomNavIndex==0?"Camera":"Employees"),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed: () {

            },
            child: Icon(Icons.add_a_photo_sharp),
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            onPressed: () {

            },
            child: Icon(Icons.person_add_rounded),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 20,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: bottomNavIndex,
        selectedFontSize: 15,
        backgroundColor: Colors.white,
        selectedIconTheme: const IconThemeData(
          color:Colors.blue,
        ),
        fixedColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Colors.black,
            icon: Icon(
                Icons.video_camera_back_rounded,
                size:35
            ),
            label: "Camera",
            activeIcon: Icon(
              Icons.video_camera_back_rounded,
                size:40

            ),
          ),

          BottomNavigationBarItem(
            icon: Icon(
                Icons.person,
                size:35
            ),
            label: "Employees",
            activeIcon: Icon(
              Icons.person,
                size:40
            ),
          ),
        ],
        onTap: (int pos){
          setState(() {
            bottomNavIndex=pos;
          });
        },
      )
    );
  }
}
