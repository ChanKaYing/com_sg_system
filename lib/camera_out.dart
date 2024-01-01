import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com_sg_system/camera_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:com_sg_system/firebase_options.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:permission_handler/permission_handler.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const CamOutPage());
}


class CamOutPage extends StatelessWidget {
  const CamOutPage({Key? key});

  // document.id


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Check-Out',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  bool _isPermissionGranted = false;
  late final Future<void> _future;
  CameraController? _cameraController;
  final textRecognizer = TextRecognizer();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _future = _requestCameraPermission();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _scanImage());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    textRecognizer.close();
    timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      _startCamera();
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String fetchedData = '';
  String approve = '' ;
  List<String> scan = [];

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _formatTime(TimeOfDay time) {
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  Future<void> fetchData() async {

    try {
      // Fetching data from the 'licenseplate' collection
      QuerySnapshot querySnapshot = await _firestore.collection('licenseplate').get();
      QuerySnapshot visitorQuerySnapshot = await _firestore.collection("carregister").get();

      setState(() {
        fetchedData = '';
        approve = '' ;
        for (var doc in querySnapshot.docs) {
          // Accessing the 'plate' field from each document
          var plate = doc['plate'];
          fetchedData += 'Plate: $plate\n';

          String oo= plate.toString();
          print("ooooooooooooooooooooooooL");

          if(scan.contains(oo)){
            print("approve");
            approve="Member Check Out Approve!";
          }
        }

        for (var doc in visitorQuerySnapshot.docs) {
          // Accessing the 'plate' field from each document
          var plate = doc['plate'];
          var estimateCheckin = doc['checkindate']+" "+doc['checkintime'];
          print("Time = ");
          fetchedData += 'Plate: $plate\n';

          String oo= plate.toString();
          print("ooooooooooooooooooooooooL");

          if(scan.contains(oo)){
            print("approve!!!");
            approve="Visitor Check Out Approve!!!";
            saveCheckOut(doc.id);
          }
        }
      });

      print("LLLLLLLLLLLLLLLLLLLLL");
      print(scan);


    } catch (e) {
      setState(() {
        fetchedData = 'Error fetching data: $e';
      });
    }
  }

  void saveCheckOut(String docID) async {
    try {
      QuerySnapshot visitorQuerySnapshot = await _firestore.collection("carregister").get();

      for (var doc in visitorQuerySnapshot.docs) {
        if(doc.id == docID){
          var plate = doc['plate'];
          var estimateCheckinDate = doc['checkindate'];
          var estimateCheckTime = doc['checkintime'];
          var name = doc['name'];
          var realCheckinDate = doc['realcheckindate'];
          var realCheckinTime = doc['realcheckintime'];
          var uid = doc['uid'];

          FirebaseFirestore.instance
              .collection('datavisitors')
              .add({
            'plate':plate,
            'checkindate': estimateCheckinDate,
            'checkintime': estimateCheckTime,
            'name': name,
            'realcheckindate': realCheckinDate,
            'realcheckintime': realCheckinTime,
            'uid': uid,
            'realcheckoutdate': _formatDate(DateTime.now()),
            'realcheckouttime': _formatTime(TimeOfDay.now()),
          });

          await FirebaseFirestore.instance
              .collection('carregister')
              .doc(docID)
              .delete();

          break;
        }
      }


/*
      FirebaseFirestore.instance
          .collection('datavisitors')
          .doc(docID)
          .add({
        'realcheckoutdate': _formatDate(DateTime.now()),
        'realcheckouttime': _formatTime(TimeOfDay.now()),
      });*/


      // Data added successfully
      print('Data added to Firestore!');
    } catch (e) {
      // Handle errors
      print('Error adding data to Firestore: $e');
    }

  }

  String getDatabaseText(){
    String pp = '';
    for (int i=0; i<scan.length;i++){
      pp = pp + scan[i] + "\n";
    }
    return pp;
  }

  @override
  Widget build(BuildContext context) {
    fetchData();

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return Stack(
          children: [
            if (_isPermissionGranted)
              FutureBuilder<List<CameraDescription>>(
                future: availableCameras(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    _initCameraController(snapshot.data!);

                    return Center(child: CameraPreview(_cameraController!));
                  } else {
                    return const LinearProgressIndicator();
                  }
                },
              ),
            Scaffold(
              appBar: AppBar(
                title: const Text('Camera Check-Out'),
              ),
              backgroundColor: _isPermissionGranted ? Colors.transparent : null,
              body: _isPermissionGranted
                  ? Column(
                children: [
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    color:Colors.white,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(getDatabaseText()),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      fetchedData.isNotEmpty
                                          ? fetchedData
                                          : 'Data is not available yet', // You can adjust the placeholder message here
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(approve
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
                  : Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(getDatabaseText()),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                fetchedData.isNotEmpty
                                    ? fetchedData
                                    : 'Data is not available yet', // You can adjust the placeholder message here
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            children: <Widget>[
                              Text(approve
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CamPage()),
                  );
                },
              ),

            ),
          ],
        );
      },
    );
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isPermissionGranted = status == PermissionStatus.granted;
  }

  void _startCamera() {
    if (_cameraController != null) {
      _cameraSelected(_cameraController!.description);
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  void _initCameraController(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }

    // Select the first rear camera.
    CameraDescription? camera;
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription current = cameras[i];
      if (current.lensDirection == CameraLensDirection.back) {
        camera = current;
        break;
      }
    }

    if (camera != null) {
      _cameraSelected(camera);
    }
  }

  Future<void> _cameraSelected(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );


    await _cameraController!.initialize();
    await _cameraController!.setFlashMode(FlashMode.off);

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _scanImage() async {
    if (_cameraController == null) return;

    final navigator = Navigator.of(context);

    try {
      final pictureFile = await _cameraController!.takePicture();

      final file = File(pictureFile.path);

      final inputImage = InputImage.fromFile(file);
//      final recognizedText = await textRecognizer.processImage(inputImage);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);


      scan = [];
      for (int i = 0 ; i<recognizedText.blocks.length; i++ ) {
        scan.add(recognizedText.blocks[i].text);
        print(scan);

      }


//      print("LLLLLLLLLLLLLLLLLLLLL");
//      print(recognizedText.text);
/*
      await navigator.push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ResultScreen(text: scan),
        ),
      );
      */
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred when scanning text'),
        ),
      );
    }
  }
}

class ResultScreen extends StatefulWidget {
  final List<String> text;
  String getText(){
    String pp = '';
    for (int i=0; i<text.length;i++){
      pp = pp + text[i];
    }
    return pp;
  }

  const ResultScreen({Key? key, required this.text});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}////

class _ResultScreenState extends State<ResultScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String fetchedData = '';
  String approve = '' ;

  Future<void> fetchData() async {
    try {
      int count=0;
      // Fetching data from the 'licenseplate' collection
      QuerySnapshot querySnapshot = await _firestore.collection('licenseplate').get();
      setState(() {
        fetchedData = '';
        for (var doc in querySnapshot.docs) {
          // Accessing the 'plate' field from each document
          var plate = doc['plate'];
          fetchedData += 'Plate: $plate\n';

          String oo= plate.toString();
          print("ooooooooooooooooooooooooL");

          if(widget.text.contains(oo)){
            print("approve");
            approve="Approve!";
          }


/*          if(oo==widget.text){
            print(oo);
            print("approve");
            approve="Approve!";
          }

 */

        }
      });

      print("LLLLLLLLLLLLLLLLLLLLL");
      print(widget.text);


    } catch (e) {
      setState(() {
        fetchedData = 'Error fetching data: $e';
      });
    }
  }



  Widget build(BuildContext context) {
    fetchData(); // Call the fetchData method to get data before building the UI

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detect Camera'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(widget.getText()),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    fetchedData.isNotEmpty
                        ? fetchedData
                        : 'Data is not available yet', // You can adjust the placeholder message here
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(approve
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
