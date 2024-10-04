import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';
import '../token.dart';
import '../utilities/button.dart';
import '../utilities/methods.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_tools/qr_code_tools.dart';




class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  var bottomNavIndex = 0;
  var isAdmin=true;
  bool isProcessing = false;

  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;
  final serialNumberController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  // final apiKey=dotenv.env['API_KEY']!;
 final apiKey="";

  Future<void> createEmployee(String name, String password,String mobile) async {
    final url = Uri.parse(apiKey+'login');

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
    final url = Uri.parse(apiKey+'login');

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
    _initializeCamera();

  }



  Future<void> _processImage() async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
    });

    // Capture the image from the camera stream
    try {
      final image = await _cameraController.takePicture();
      String? qrCode = await _decodeQRCode(image);
      if (qrCode != null) {
        serialNumberController.text = qrCode; // Set the QR code to the TextField
      } else {
        // Handle QR code not found scenario
        print("No QR code found in the image.");
      }
    } catch (e) {
      print("Error processing image: $e");
    } finally {
      setState(() {
        isProcessing = false;
      });
    }
  }


  Future<String?> _decodeQRCode(XFile image) async {
    try {
      String? result = await QrCodeToolsPlugin.decodeFrom(image.path);
      return result;
    } catch (e) {
      print('Error decoding QR code: $e');
      return null;
    }
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    await Permission.camera.request();

    // Check if the permission was granted
    if (await Permission.camera.isGranted) {
      // Get available cameras
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      // Initialize the camera controller
      _cameraController = CameraController(
        firstCamera,
        ResolutionPreset.high,
      );
      // Initialize the controller
      _initializeControllerFuture = _cameraController.initialize();
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
                        child: Container(
                            height:getHeight(context)*0.8,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Scaffold(
                                backgroundColor: Colors.grey.shade100,
                                body: CustomScrollView(
                                  shrinkWrap: false,
                                  physics:  BouncingScrollPhysics(),
                                  scrollBehavior: ScrollBehavior(),
                                  slivers: [
                                    const SliverAppBar(
                                      pinned:false,
                                      floating: true,
                                      title: Text("Register Camera"),
                                      automaticallyImplyLeading: false,
                                      centerTitle: true,
                                    ),
                                    SliverToBoxAdapter(
                                      child: Container(
                                        height: getHeight(context)*1.5,
                                        child: Column(
                                          children: [


                                            Container(
                                              child:  FutureBuilder<void>(
                                                future: _initializeControllerFuture,
                                                builder: (context, snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done) {
                                                    // If the controller is initialized, display the camera preview
                                                    return SizedBox(
                                                      width: getWidth(context),
                                                      height: getHeight(context)*0.5,
                                                      child:  CameraPreview(_cameraController),
                                                    );
                                                  } else {
                                                    // Otherwise, show a loading indicator
                                                    return const Center(child: CircularProgressIndicator());
                                                  }
                                                },
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




                                            Text("Selected Location"),
                                            DropdownButton(
                                                items: [

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
                                  onPressed:_processImage,


                                  backgroundColor: Colors.blue,
                                  child: Icon(Icons.qr_code_2_rounded, size: 45, color: Colors.white),
                                ),

                              ),
                            ),
                        ),
                      );
                  });
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
              showModalBottomSheet(
                  context: context,
                  isScrollControlled:true,
                  enableDrag: true, // Set to true if you want drag functionality
                  builder: (BuildContext context){
                    return
                      ClipRRect(
                        child: Container(
                          height:getHeight(context)*0.8,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Scaffold(
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                body: CustomScrollView(
                                  shrinkWrap: false,
                                  physics:  BouncingScrollPhysics(),
                                  scrollBehavior: ScrollBehavior(),
                                  slivers: [
                                    const SliverAppBar(
                                      pinned:false,
                                      floating: true,
                                      title: Text("Register Employee"),
                                      automaticallyImplyLeading: false,
                                      centerTitle: true,
                                    ),
                                    SliverToBoxAdapter(
                                        child: Container(
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
