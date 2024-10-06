import 'dart:convert';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
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
  bool isProcessing = false;
  XFile? capturedImage;
  String? decodedQRCode;
  bool isAdmin=false;
  final serialNumberController = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? selectedPollingStationId;
  bool isDropdownOpen = false;
  List<String> pollingStationIdList=['Select polling station'];



  // final apiKey=dotenv.env['API_KEY']!;
  // final apiKey="";

  String apiKey="http://192.168.1.8:2000/";

  void fetchInfo(){
    fetchPollingStation();
  }

  Future<void> fetchPollingStation() async{
    String? token = await storage.read(key: 'authToken');

    final url = Uri.parse('${apiKey}getPollingStation');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Fetched info successfully: ${response.body}');
        final List<dynamic> responseData = jsonDecode(response.body);

        setState(() {
          pollingStationIdList = responseData.map((data) {
            return data['polling_station'] as String;
          }).toList();
        });

      } else {
        print('Fetch failed: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }


  Future<void> authenticateToken() async {
    String? token = await storage.read(key: 'authToken');

    final url = Uri.parse(apiKey+'authenticateToken');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Login successful: ${response.body}');
        final responseData = jsonDecode(response.body);

        setState(() {
          isAdmin = responseData['isAdmin'];
        });

        print('===========================$isAdmin=============================');
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        removeToken();
        Navigator.pushNamed(context, '/login');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }



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
    authenticateToken();
    fetchInfo();
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
              backgroundColor: Colors.white,
              elevation: 20,
              automaticallyImplyLeading: false,
              floating: true,
              pinned:false,
              title: Text(bottomNavIndex==0?"Camera":"Employees"),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: isAdmin? Column(
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

                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                                                    child: Text("Polling Station :"),
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                                child:
                                                CustomDropdown<String>(
                                                  hintText: 'Select Polling station',
                                                  items: pollingStationIdList,
                                                  initialItem: pollingStationIdList[0],
                                                  onChanged: (value) {
                                                    print("value = ");
                                                  },
                                                ),
                                              ),

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
                                  child: const Icon(Icons.send_rounded, size: 45, color: Colors.white),
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
        ):Container(),
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
