//로딩 page
//위치정보, 데이터 가져오기

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:zoo_app/screens/stamp_screen.dart';
import 'package:zoo_app/size.dart';
import '../data/firestore_data_control.dart';
import 'package:tflite/tflite.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late AnimationController _controller; //progress bar를 위한 _controller
  bool _modelStatus = false;
  @override
  void initState() {
    //gps좌표 받아오기(사진찍을때만 필요한가...)
    _checkPermission();
    InitFireStore(); //init firestore
    _loadMlModel(); //init tflite

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          // progress bar가 다 찼고, 유저의 스탬프를 받아왔다면 다음화면으로
          if (_controller.isCompleted && _modelStatus) {
            print('loading complt');
            print('is model loaded: ${_modelStatus}');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => stampScreen()),
              (route) => false,
            );
          }
        });
      });

    _controller.forward(); //start progressbar
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadMlModel() async {
    var res = await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/model.txt',
    ).whenComplete(() {
      setState(() {
        _modelStatus = true;
      });
    });
    print('LoadModel: ${res}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.amber,
      backgroundColor: const Color(0xfff3c766),
      body: LoadingPage(_controller),
    );
  }

  Future<void> InitFireStore() async {
    //get user stamp data
    try {
      await Firebase.initializeApp();
    } catch (err) {
      print('error: from init FireStore');
    }
  }

  Widget LoadingPage(AnimationController _controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 133 * getScaleHeight(context)),
          //로딩 화면에 네모와 사진을 스택으로
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                width: 200 * getScaleWidth(context),
                height: 200 * getScaleHeight(context),
                decoration: BoxDecoration(
                  color: const Color(0xfff8a442),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x66000000),
                      offset: Offset(0, 3),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
              ),
              Image.asset(
                'images/giraffe.png',
                width: 150 * getScaleWidth(context),
                height: 150 * getScaleHeight(context),
              ),
            ],
          ),
          SizedBox(height: 10 * getScaleHeight(context)),

          //앱 이름
          Text(
            'Zoo App',
            style: TextStyle(
              color: Color(0xfffefffb),
              fontWeight: FontWeight.w400,
              fontFamily: 'NotoSans',
              fontStyle: FontStyle.normal,
              fontSize: 30.0,
            ),
          ),
          SizedBox(height: 258 * getScaleHeight(context)),

          //컨테이너와 progressbar를 겹쳐서 그림자 표시하고 둥글게 만듦
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 31 * getScaleHeight(context),
                width: 160 * getScaleWidth(context),
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: const Color(0x66000000),
                    offset: Offset(0, 3),
                    blurRadius: 6.0,
                  )
                ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: LinearProgressIndicator(
                    value: _controller.value,
                    color: const Color(0xfff8a442),
                  ),
                ),
              ),
              Text(
                '로딩중입니다.',
                style: const TextStyle(
                  color: const Color(0xfffefffb),
                  fontWeight: FontWeight.w400,
                  fontFamily: "NotoSans",
                  fontStyle: FontStyle.normal,
                  fontSize: 15.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

_checkPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
}
