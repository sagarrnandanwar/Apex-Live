import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import '../token.dart';
import '../utilities/button.dart';
import '../utilities/methods.dart';
import 'package:http/http.dart' as http;



class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var bottomNavIndex = 0;
  var isAdmin=true;
  bool isProcessing = false;
  XFile? capturedImage;
  String? decodedQRCode;
  final serialNumberController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // final apiKey=dotenv.env['API_KEY']!;
  final apiKey="";

  Future<void> createEmployee(String name, String password,String mobile) async {
    final url = Uri.parse('${apiKey}login');

    final body = jsonEncode({
      'name': name,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('token')) {
          String token = responseData['token'];
          await saveToken(token);

          print('Login successful: ${response.body}');
          Navigator.pushNamed(context, '/home');
        } else {
          print('Token not found in response');
        }
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }


  Future<void> createCamera(String projectName, String Location,String Model) async {
    final url = Uri.parse('${apiKey}login');

    final body = jsonEncode({
      'projectName': projectName,
      'location': Location,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData.containsKey('token')) {
          String token = responseData['token'];
          await saveToken(token);

          print('Login successful: ${response.body}');
          Navigator.pushNamed(context, '/home');
        } else {
          print('Token not found in response');
        }
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestCameraPermission();

  }

  Future<void> _requestCameraPermission() async {
    if (await Permission.camera.request().isGranted) {
      // Camera permission granted
    } else {
      // Handle the case where the permission is denied
      print('Camera permission denied');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
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
                showModalBottomSheet(
                    context: context,
                    isScrollControlled:true,
                    enableDrag: true, // Set to true if you want drag functionality
                    builder: (BuildContext context){
                      return
                        ClipRRect(
                          child: SizedBox(
                            height:getHeight(context)*0.8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Scaffold(
                                backgroundColor: Colors.grey.shade100,
                                body: CustomScrollView(
                                  shrinkWrap: false,
                                  physics:  const BouncingScrollPhysics(),
                                  scrollBehavior: const ScrollBehavior(),
                                  slivers: [
                                    const SliverAppBar(
                                      pinned:false,
                                      floating: true,
                                      title: Text("Register Camera"),
                                      automaticallyImplyLeading: false,
                                      centerTitle: true,
                                    ),
                                    SliverToBoxAdapter(
                                        child: SizedBox(
                                          height: getHeight(context)*1.5,
                                          child: Column(
                                            children: [

                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(20),
                                                child: SizedBox(
                                                  height: getHeight(context)*0.4,
                                                  width: getWidth(context)*0.8,
                                                  child: Expanded(
                                                    child: MobileScanner(
                                                      onDetect: (BarcodeCapture barcodeCapture) {
                                                        final String? code = barcodeCapture.barcodes.first.rawValue;
                                                        if (code != null) {
                                                          setState(() {
                                                            serialNumberController.text=code;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 24, right: 24, top: 30,bottom:30),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: TextField(
                                                    controller: serialNumberController,
                                                    decoration: const InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      prefixIcon: Icon(Icons.numbers_rounded),
                                                      hintText: "Model Number",
                                                      border: InputBorder.none,
                                                    ),
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              ),




                                              const Text("Selected Location"),
                                              DropdownButton(
                                                  items: const [

                                                  ],
                                                  onChanged: (index){

                                                  }
                                              ),
                                              Button(
                                                  context,
                                                  getWidth(context)*0.7,
                                                  "Create Camera",
                                                      () async {
                                                    await createCamera("Project Name","Location","Model Number");
                                                  }
                                              )
                                            ],
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                                floatingActionButton: FloatingActionButton.large(

                                  onPressed: (){},
                                  backgroundColor: Colors.blue,
                                  child: const Icon(Icons.qr_code_2_rounded, size: 45, color: Colors.white),
                                ),

                              ),
                            ),
                          ),
                        );
                    });
              },
              child: const Icon(Icons.add_a_photo_sharp),
            ),
            const SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled:true,
                    enableDrag: true, // Set to true if you want drag functionality
                    builder: (BuildContext context){
                      return
                        ClipRRect(
                          child: SizedBox(
                            height:getHeight(context)*0.8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Scaffold(
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                body: CustomScrollView(
                                  shrinkWrap: false,
                                  physics:  const BouncingScrollPhysics(),
                                  scrollBehavior: const ScrollBehavior(),
                                  slivers: [
                                    const SliverAppBar(
                                      pinned:false,
                                      floating: true,
                                      title: Text("Register Employee"),
                                      automaticallyImplyLeading: false,
                                      centerTitle: true,
                                    ),
                                    SliverToBoxAdapter(
                                        child: SizedBox(
                                          height: getHeight(context)*1.5,
                                          child: Column(
                                            children: [


                                              Padding(
                                                padding: const EdgeInsets.only(left: 24, right: 24, top: 25,bottom:10),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: TextField(
                                                    controller: serialNumberController,
                                                    decoration: const InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      prefixIcon: Icon(Icons.person),
                                                      hintText: "full_name",
                                                      border: InputBorder.none,
                                                    ),
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 24, right: 24, top: 10,bottom:10),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: TextField(
                                                    controller: serialNumberController,
                                                    decoration: const InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      prefixIcon: Icon(Icons.password),
                                                      hintText: "password",
                                                      border: InputBorder.none,
                                                    ),
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(left: 24, right: 24, top: 10,bottom:10),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10),
                                                  child: TextField(
                                                    controller: serialNumberController,
                                                    decoration: const InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      prefixIcon: Icon(Icons.phone),
                                                      hintText: "mobile_number",
                                                      border: InputBorder.none,
                                                    ),
                                                    style: const TextStyle(color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                              Button(
                                                  context,
                                                  getWidth(context)*0.7,
                                                  "Create Employee",
                                                      () async {
                                                    await createEmployee("name","password","mobile");
                                                  }
                                              )
                                            ],
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                    });
              },
              child: const Icon(Icons.person_add_rounded),
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
